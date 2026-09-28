from pathlib import Path
from typing import Annotated

import tomlkit
import typer
from rich.console import Console

from dot.functions.install import _resolve_adapter
from dot.types.shared import REPO_ROOT
from dot.types.software import BASE_SOFTWARE_PATH, PackageManagerName, PackageName
from dot.utils.dispatch import install_packages, refresh_all
from dot.utils.profile import PROFILES_DIR, detect_system, get_available_profiles
from dot.utils.symbols import FAIL, NEUTRAL, OK

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()

Additions = dict[PackageManagerName, list[PackageName]]


@app.command(name="add | a")
def add(
    specs: Annotated[
        list[str],
        typer.Argument(help="Packages to add, as manager:pkg1,pkg2."),
    ],
    profile: Annotated[
        str | None,
        typer.Option("--profile", "-p", help="Profile to add to (root by default)."),
    ] = None,
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
) -> None:
    """Add packages to a profile's SOFTWARE.toml and install them."""
    additions = _parse_specs(specs)

    path = _resolve_target(profile)
    _write_software(path, additions, dry_run=dry_run)

    refresh_all(managers=list(additions), dry_run=dry_run)
    _install(additions, dry_run=dry_run)


def _parse_specs(specs: list[str]) -> Additions:
    """Parse `manager:pkg1,pkg2` specs into a manager -> packages mapping."""
    parsed: Additions = {}
    for spec in specs:
        manager, sep, rest = spec.partition(":")
        manager = manager.strip()
        packages = [p.strip() for p in rest.split(",") if p.strip()]
        if not sep or not manager or not packages:
            console.print(f"[red]{FAIL} Invalid spec {spec!r}, expected manager:pkg[/]")
            raise typer.Exit(1)

        for package in packages:
            if package not in parsed.setdefault(manager, []):
                parsed[manager].append(package)

    return parsed


def _resolve_target(profile: str | None) -> Path:
    """Resolve the target profile's SOFTWARE.toml path (root when unset)."""
    if profile is None or profile.lower() == "default":
        return BASE_SOFTWARE_PATH

    if profile not in get_available_profiles():
        console.print(f"[red]{FAIL} Profile {profile} not found[/]")
        raise typer.Exit(1)

    return PROFILES_DIR / profile / "SOFTWARE.toml"


def _write_software(path: Path, additions: Additions, *, dry_run: bool) -> None:
    """Append packages to each manager's list, skipping ones already present."""
    doc = tomlkit.parse(path.read_text()) if path.is_file() else tomlkit.document()
    rel = path.relative_to(REPO_ROOT)
    label = "[PLANNED]" if dry_run else OK

    for manager, packages in additions.items():
        array = doc.get(manager)
        if array is None:
            array = tomlkit.array().multiline(True)
            doc[manager] = array

        existing = {str(entry) for entry in array}
        for package in packages:
            if package in existing:
                console.print(
                    f"[yellow]{NEUTRAL} {manager}: {package} already listed[/]"
                )
                continue
            array.append(package)
            console.print(f"{label} ADD {rel}: {manager} += {package}")

    if not dry_run:
        path.write_text(tomlkit.dumps(doc))


def _install(additions: Additions, *, dry_run: bool) -> None:
    """Install the added packages for each resolvable manager."""
    system = detect_system()
    for manager, packages in additions.items():
        resolved = _resolve_adapter(manager, system)
        if resolved is None:
            continue

        name, adapter = resolved
        console.rule(name, align="right")
        install_packages(adapter, packages, dry_run=dry_run)
