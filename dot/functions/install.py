import subprocess

from rich.console import Console

from dot.types.shared import Distro
from dot.types.software import (
    PACKAGE_MANAGERS,
    PackageAdapter,
    PackageName,
    SoftwareEntry,
)
from dot.utils.dispatch import (
    get_enabled_managers,
    install_packages,
    try_install_package,
)
from dot.utils.hooks import run_hooks
from dot.utils.profile import (
    ActiveProfiles,
    System,
    detect_system,
    merge_software,
    profile_cwd,
)
from dot.utils.symbols import FAIL, NEUTRAL, OK
from dot.utils.system_manager import resolve_system_manager

console = Console()


def run_install(
    active_profiles: ActiveProfiles,
    managers: str | None = None,
    dry_run: bool = False,
    suppress_hooks: bool = False,
) -> None:
    """Install/sync software for the active profiles.

    Assumes refreshed indices.
    """
    software = merge_software(active_profiles)

    if not suppress_hooks:
        for name, config in active_profiles:
            run_hooks(
                config.hooks,
                "before",
                "install",
                cwd=profile_cwd(name),
                dry_run=dry_run,
            )

    selected = {name.strip() for name in managers.split(",")} if managers else None
    system = detect_system()
    for manager, to_install in software.items():
        if selected is not None and manager not in selected:
            continue

        resolved = _resolve_adapter(manager, system)
        if resolved is None:
            continue
        console.rule(manager, align="right")
        name, adapter = resolved

        batchable, serial = _classify_entry(to_install, name, system)

        # Attempt every unit independently, track overall failure
        attempts = 0
        failures = 0

        if batchable:
            attempts += 1
            try:
                install_packages(adapter, batchable, dry_run=dry_run)
            except subprocess.CalledProcessError:
                failures += 1

        for aliases in serial:
            attempts += 1
            try:
                if not _install_aliases(adapter, name, aliases, dry_run=dry_run):
                    failures += 1
            except subprocess.CalledProcessError:
                failures += 1

        succeeded = not attempts or failures < attempts
        console.rule(f"{OK if succeeded else FAIL} {manager}", align="left")

    if not suppress_hooks:
        for name, config in active_profiles:
            run_hooks(
                config.hooks, "after", "install", cwd=profile_cwd(name), dry_run=dry_run
            )


def _resolve_adapter(manager: str, system: System) -> tuple[str, PackageAdapter] | None:
    """Resolve a software key to (manager, adapter), skipping unknown/inactive."""
    if manager == "system":
        resolved = resolve_system_manager(
            PACKAGE_MANAGERS, os=system.os, distro=system.distro
        )
        if resolved is None:
            console.print("[yellow]No system manager for this machine, skipping...[/]")
        return resolved

    if manager not in PACKAGE_MANAGERS:
        console.print(
            f"[yellow]{NEUTRAL} Manager {manager} is not known, skipping...[/]"
        )
        return None

    available = get_enabled_managers()
    if manager not in available:
        console.print(
            f"[yellow]{NEUTRAL} Manager {manager} is not active, skipping...[/]"
        )
        return None

    return manager, available[manager]


def _classify_entry(
    to_install: list[SoftwareEntry], manager: str, system: System
) -> tuple[list[PackageName], list[list[PackageName]]]:
    """Split entries into a batchable list and serial alias-groups, resolving dict entries."""
    batchable: list[PackageName] = []
    serial: list[list[PackageName]] = []

    for item in to_install:
        if isinstance(item, str):
            batchable.append(item)
        elif isinstance(item, list):
            serial.append(item)
        else:
            entry = _resolve_entry(item, manager, system)
            if isinstance(entry, list):
                serial.append(entry)
            elif entry is not None:
                batchable.append(entry)

    return batchable, serial


def _resolve_entry(
    item: dict[Distro, PackageName | list[PackageName]], manager: str, system: System
) -> PackageName | list[PackageName] | None:
    """Resolve entry special behaviors."""
    if manager == "gearlever":
        return f"{item['name']}={item['url']}"
    if manager == "cargo" and "git" in item:
        names = item.get("names", [])
        if isinstance(names, str):
            names = [names]
        return f"{','.join(names)}={item['git']}"

    if system.distro in item:
        return item[system.distro]
    if "default" in item:
        return item["default"]

    console.print(f"[yellow]Distro {system.distro} not in {item}, skipping...[/]")
    return None


def _install_aliases(
    adapter: PackageAdapter,
    manager: str,
    aliases: list[PackageName],
    *,
    dry_run: bool = False,
) -> bool:
    """Install one alias-group, trying candidates in order.

    Returns:
        Whether an alias succeeded.
    """
    if not aliases:
        return True
    if len(aliases) == 1:
        install_packages(adapter, aliases, dry_run=dry_run)
        return True
    if dry_run:
        console.print(
            adapter.install.replace("{packages}", "{" + ", ".join(aliases) + "}")
        )
        return True

    result = None
    for candidate in aliases:
        result = try_install_package(adapter, [candidate])
        if result.returncode == 0:
            break

    if result is None:
        return True

    if result.returncode != 0:
        console.print(f"[yellow]{manager}: could not install any of {aliases}[/]")

    output = f"{result.stderr or ''}{result.stdout or ''}".strip()
    if output:
        console.print(output)

    return result.returncode == 0
