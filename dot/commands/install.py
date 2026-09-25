from typing import Annotated

import typer
from rich.console import Console

from dot.functions.install import run_install
from dot.utils.dispatch import refresh_all
from dot.utils.profile import resolve_active

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()


@app.command(name="install | i")
def install(
    profiles: Annotated[
        list[str],
        typer.Argument(
            default_factory=list, help="Profiles to activate (detects by default)."
        ),
    ],
    managers: Annotated[
        str | None,
        typer.Option(
            "--managers", "-m", help="Limit to these managers (comma-separated)."
        ),
    ] = None,
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
    suppress_hooks: Annotated[
        bool, typer.Option("--suppress-hooks", "-H", help="Don't run hooks.")
    ] = False,
) -> None:
    """Install software for active profiles."""
    active_profiles = resolve_active(profiles or None)
    refresh_all(dry_run=dry_run)

    run_install(active_profiles, managers, dry_run, suppress_hooks=suppress_hooks)
