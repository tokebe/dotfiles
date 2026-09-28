import subprocess
import time
from collections import Counter
from collections.abc import Callable
from typing import Literal

from InquirerPy import inquirer
from InquirerPy.base.control import Choice
from rich.console import Console
from rich.table import Table

from dot.types.software import PACKAGE_MANAGERS
from dot.utils.dispatch import check_updates, get_enabled_managers, upgrade_packages
from dot.utils.hooks import run_hooks
from dot.utils.profile import ActiveProfiles, profile_cwd, resolve_active
from dot.utils.progress import live_progress
from dot.utils.symbols import FAIL, NEUTRAL, OK

console = Console()

STEP_PAUSE = (
    0.5  # If a check step produces output, hold long enough for the eye to register
)


def run_update(
    managers: list[str],
    update_all: bool = False,
    dry_run: bool = False,
    suppress_hooks: bool = False,
    active_profiles: ActiveProfiles | None = None,
) -> None:
    """Update installed packages for the given managers (or all / interactively)."""
    profiles = active_profiles if active_profiles is not None else resolve_active(None)

    def fire_hooks(timing: Literal["before", "after"], stage: str | None = None) -> None:
        if suppress_hooks:
            return
        for name, config in profiles:
            run_hooks(
                config.hooks,
                timing,
                "update",
                stage=stage,
                cwd=profile_cwd(name),
                dry_run=dry_run,
            )

    fire_hooks("before")

    selection = _resolve_selection(managers, update_all)

    if dry_run:
        _report_available(selection)
        _run_upgrades(selection, fire_hooks, dry_run=True)
        fire_hooks("after")
        return

    # Get interactive selection if no manual was done
    if not (managers or update_all):
        selection = get_user_selection()

    did_updates, failures = _run_upgrades(selection, fire_hooks)

    fire_hooks("after")

    if failures:
        console.print(
            f"[yellow]{NEUTRAL} Update finished with failures: {', '.join(failures)}[/]"
        )
    elif did_updates:
        console.print(f"[green]{OK} Update complete![/]")
    else:
        console.print(f"[yellow]{NEUTRAL} Nothing to update.[/]")


def _resolve_selection(managers: list[str], update_all: bool) -> list[str]:
    """Filter the requested managers to those known and currently active."""
    adapters = get_enabled_managers()
    selection = list(adapters) if update_all else list(set(managers))

    for manager in list(selection):
        if manager not in PACKAGE_MANAGERS:
            console.print(f"[yellow]Manager {manager} is not known, skipping...[/]")
            selection.remove(manager)
        elif manager not in adapters:
            console.print(f"[yellow]Manager {manager} is not active, skipping...[/]")
            selection.remove(manager)

    return selection


def _report_available(selection: list[str]) -> None:
    """Print the per-manager count of available updates."""
    counts = get_update_counts(selection)

    console.print("Available updates:")
    table = Table(box=None, show_header=False, pad_edge=True)
    table.add_column("package manager", justify="right")
    table.add_column("count", justify="left")
    for name, count in counts.items():
        table.add_row(name, str(count))

    console.print(table)


def _run_upgrades(
    selection: list[str],
    fire_hooks: Callable[..., None],
    *,
    dry_run: bool = False,
) -> tuple[bool, list[str]]:
    """Upgrade each selected manager, isolating failures so the rest still run.

    A dry run fires the stage hooks (as planned) but skips the actual upgrade.
    """
    did_updates = False
    failures: list[str] = []

    for manager in selection:
        fire_hooks("before", manager)

        if dry_run:
            console.print(f"[bright_black]\\[PLANNED] update {manager}[/]")
        else:
            console.print(f"Updating {manager}...")
            try:
                upgrade_packages(PACKAGE_MANAGERS[manager])
                did_updates = True
            except subprocess.CalledProcessError as err:
                console.print(
                    f"[red]{FAIL} {manager} update failed (exit {err.returncode}), skipping...[/]"
                )
                failures.append(manager)

        fire_hooks("after", manager)

    return did_updates, failures


def get_user_selection() -> list[str]:
    """Check which adapters have updates and get user selection."""
    counts = get_update_counts()
    choices = [
        Choice(
            name,
            f"{name} ({count})",
            enabled=bool(count),
        )
        for name, count in sorted(counts.items(), key=lambda i: i[1], reverse=True)
    ]
    return inquirer.checkbox(
        "Select managers to update:",
        choices=choices,
        disabled_symbol="󰄰 ",
        enabled_symbol="󰄴 ",
        qmark="? ",
        transformer=lambda names: ", ".join(n.rsplit(" (", 1)[0] for n in names),
        amark=" ",
    ).execute()


def get_update_counts(pre_selections: list[str] | None = None) -> Counter:
    """Get counts of available updates."""
    adapters = get_enabled_managers()
    if pre_selections:
        adapters = {
            name: adapter
            for name, adapter in adapters.items()
            if name in pre_selections
        }
    counts = Counter()
    with live_progress(bar_width=len(adapters)) as (window, progress):
        task = progress.add_task("Checking for updates", total=len(adapters))
        for name, adapter in adapters.items():
            window.clear()
            progress.update(
                task,
                description=f"Checking for updates ({name})",
            )
            counts[name] += check_updates(adapter, window.write)
            progress.advance(task)

            if window.lines:
                time.sleep(STEP_PAUSE)

    return counts
