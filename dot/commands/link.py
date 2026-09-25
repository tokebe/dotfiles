from typing import Annotated

import typer
from rich.console import Console

from dot.functions.link import Phases, run_link
from dot.utils.profile import resolve_active

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()


@app.command(name="link | l")
def link(  # noqa: PLR0913, PLR0917
    profiles: Annotated[
        list[str],
        typer.Argument(
            default_factory=list, help="Profiles to activate (detects by default.)."
        ),
    ],
    create: Annotated[
        bool, typer.Option("--create", "-c", help="Only create configured dirs.")
    ] = False,
    clean: Annotated[
        bool, typer.Option("--clean", "-x", help="Only clean dead repo symlinks.")
    ] = False,
    link: Annotated[
        bool, typer.Option("--link", "-l", help="Only apply link rules.")
    ] = False,
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
    suppress_hooks: Annotated[
        bool, typer.Option("--suppress-hooks", "-H", help="Don't run hooks.")
    ] = False,
) -> None:
    """Symlink configured files and create/clean configured dirs."""
    active_profiles = resolve_active(profiles or None)
    phases: Phases = set()
    if create:
        phases.add("create")
    if clean:
        phases.add("clean")
    if link:
        phases.add("link")

    run_link(
        active_profiles,
        phases=phases,
        dry_run=dry_run,
        suppress_hooks=suppress_hooks,
    )
