import functools
from typing import Annotated

import typer
from InquirerPy import inquirer
from InquirerPy.base.control import Choice
from rich.console import Console

from dot.types.config import CONFIG, Hook
from dot.utils.hooks import run_hook, run_hooks
from dot.utils.profile import (
    ActiveProfiles,
    get_available_profiles,
    merge_software,
    profile_cwd,
    resolve_active,
)

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()


@app.command(name="hook | h")
def hook(  # noqa: PLR0913, PLR0917
    profiles: Annotated[
        list[str],
        typer.Argument(
            default_factory=list, help="Profiles to activate (detects by default)."
        ),
    ],
    events: Annotated[
        str | None,
        typer.Option("--events", "-e", help="Events to run (comma-separated)."),
    ] = None,
    before: Annotated[
        bool, typer.Option("--before", "-b", help="Only run before hooks.")
    ] = False,
    after: Annotated[
        bool, typer.Option("--after", "-a", help="Only run after hooks.")
    ] = False,
    select: Annotated[
        bool,
        typer.Option(
            "--select",
            "-s",
            help="Fuzzy-select from every hook across all profiles.",
        ),
    ] = False,
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
) -> None:
    """Run hooks as a one-off."""
    if select:
        _run_selected(dry_run)
        return

    both = not (before or after)
    run_before = before or both
    run_after = after or both

    active_profiles = resolve_active(profiles or None)

    selected = _select_events(events, active_profiles)

    for event in selected:
        if run_before:
            for name, config in active_profiles:
                run_hooks(
                    config.hooks,
                    "before",
                    event,
                    cwd=profile_cwd(name),
                    dry_run=dry_run,
                )
        if run_after:
            for name, config in active_profiles:
                run_hooks(
                    config.hooks, "after", event, cwd=profile_cwd(name), dry_run=dry_run
                )


def _select_events(events: str | None, active_profiles: ActiveProfiles) -> list[str]:
    """Parse -e, or prompt to run every event that has hooks across the active profiles."""
    if events is not None:
        return [event.strip() for event in events.split(",") if event.strip()]

    available = sorted(
        {
            event
            for _, config in active_profiles
            for bound in (config.hooks.before, config.hooks.after)
            for event in bound
        }
    )
    if not available:
        console.print("[yellow]No hooks defined for the active profiles.[/]")
        return []

    prompt = f"Run hooks for all events ({', '.join(available)})?"
    return available if inquirer.confirm(prompt, default=True).execute() else []


CollectedHook = tuple[str, str, str, Hook]

# Deploy runs its events in this order, with deploy's hooks wrapping the run.
EVENT_ORDER = {"link": 1, "install": 2, "update": 3}
# link fires these stages in order while install/update stage on package managers.
LINK_STAGE_ORDER = {"create": 0, "clean": 1, "link": 2}


def _run_selected(dry_run: bool) -> None:
    """Fuzzy-select from every hook across all profiles and run the chosen ones in order."""
    collected = _collect_all_hooks()
    if not collected:
        console.print("[yellow]No hooks defined in any profile.[/]")
        return

    choices = [Choice(index, _label(entry)) for index, entry in enumerate(collected)]
    selected = inquirer.fuzzy(
        "Select hooks to run:",
        choices=choices,
        multiselect=True,
        marker="󰄴  ",
        marker_pl="󰄰  ",
        qmark="? ",
        amark=" ",
        transformer=lambda result: f"{len(result)} hook(s)",
    ).execute()

    for index in sorted(selected):
        profile, timing, _event, hook = collected[index]
        run_hook(hook, timing, cwd=profile_cwd(profile), dryrun=dry_run)


def _label(entry: CollectedHook) -> str:
    """Render a picker row."""
    profile, timing, event, hook = entry
    stage = f"/{hook.stage}" if hook.stage else ""
    return f"{profile} · {timing} {event}{stage} · {hook.name}"


def _collect_all_hooks() -> list[CollectedHook]:
    """Flatten every hook from DEFAULT and all profiles, sorted into real run order."""
    all_profiles: ActiveProfiles = [
        ("DEFAULT", CONFIG),
        *get_available_profiles().items(),
    ]

    collected = [
        (profile, timing, event, hook)
        for profile, config in all_profiles
        for timing in ("before", "after")
        for event, hooks in config.hooks.get(timing).items()
        for hook in hooks
    ]

    # Stable sort keeps each profile's listed hook order within a matching group.
    return sorted(collected, key=_run_order_key)


def _run_order_key(entry: CollectedHook) -> tuple[int, int, int, int, float]:
    """Sort key mirroring a real deploy: event, then phase/stage/timing, then priority."""
    profile, timing, event, hook = entry

    return (
        _event_rank(event, timing),
        _phase_rank(hook.stage, timing),
        _stage_rank(hook.stage),
        0 if timing == "before" else 1,
        _profile_priority(profile),
    )


def _event_rank(event: str, timing: str) -> int:
    """deploy/before opens the run and deploy/after closes it; others fall in between."""
    if event == "deploy":
        return 0 if timing == "before" else 100
    return EVENT_ORDER.get(event, 50)


def _phase_rank(stage: str | None, timing: str) -> int:
    """Within an event the unstaged before opens, staged hooks run, the unstaged after closes."""
    if stage is not None:
        return 1
    return 0 if timing == "before" else 2


def _stage_rank(stage: str | None) -> int:
    """Order staged hooks by link's stages, else by merged SOFTWARE.toml order."""
    if stage is None:
        return 0
    return LINK_STAGE_ORDER.get(stage, _manager_order().get(stage, 10_000))


@functools.cache
def _manager_order() -> dict[str, int]:
    """Manager stage order as install iterates it: first appearance across merged SOFTWARE.toml."""
    all_profiles: ActiveProfiles = [
        ("DEFAULT", CONFIG),
        *get_available_profiles().items(),
    ]
    software = merge_software(all_profiles)
    return {manager: index for index, manager in enumerate(software)}


def _profile_priority(profile: str) -> float:
    """DEFAULT always fires first; other profiles fire by their configured priority."""
    if profile == "DEFAULT":
        return float("-inf")
    config = get_available_profiles().get(profile)
    return config.profile.priority if config else 0
