from typing import Annotated

import typer

from dot.functions.update import run_update
from dot.utils.dispatch import refresh_all

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)


@app.command(name="update | u")
def update(
    managers: Annotated[
        list[str], typer.Argument(default_factory=list, help="Managers to update.")
    ],
    update_all: Annotated[
        bool, typer.Option("--all", "-a", help="Update all managers.")
    ] = False,
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
    suppress_hooks: Annotated[
        bool, typer.Option("--suppress-hooks", "-H", help="Don't run hooks.")
    ] = False,
) -> None:
    """Update installed packages."""
    refresh_all()  # always sync, even on a dry run, so the reported counts are accurate

    run_update(managers, update_all, dry_run, suppress_hooks=suppress_hooks)
