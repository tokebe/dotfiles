from typing import Annotated

import typer
from InquirerPy import inquirer
from rich.console import Console

from dot.utils.hooks import run_hooks
from dot.utils.profile import ActiveProfiles, profile_cwd, resolve_active

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()


@app.command(name="hook | h")
def hook(
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
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
) -> None:
    """Run hooks as a one-off."""
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
