from typing import Annotated

import typer
from rich.console import Console
from rich.table import Table

from dot.functions.install import run_install
from dot.functions.link import run_link
from dot.functions.update import run_update
from dot.utils.dispatch import refresh_all
from dot.utils.hooks import run_hooks
from dot.utils.profile import ActiveProfiles, profile_cwd, resolve_active

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()


@app.command(name="deploy | d")
def deploy(
    profiles: Annotated[
        list[str],
        typer.Argument(
            default_factory=list, help="Profiles to activate (detects by default)."
        ),
    ],
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
    suppress_hooks: Annotated[
        bool, typer.Option("--suppress-hooks", "-H", help="Skip hooks.")
    ] = False,
) -> None:
    """Run a full deployment (link, install, update)."""
    active_profiles: ActiveProfiles = resolve_active(profiles or None)
    refresh_all(dry_run=dry_run)

    if not suppress_hooks:
        for name, config in active_profiles:
            run_hooks(
                config.hooks, "before", "deploy", cwd=profile_cwd(name), dry_run=dry_run
            )

    console.rule("[bold]Link[/]")
    run_link(active_profiles, dry_run=dry_run, suppress_hooks=suppress_hooks)

    console.rule("[bold]Install[/]")
    run_install(active_profiles, dry_run=dry_run, suppress_hooks=suppress_hooks)

    console.rule("[bold]Update[/]")
    run_update([], update_all=True, dry_run=dry_run, suppress_hooks=suppress_hooks)

    if not suppress_hooks:
        for name, config in active_profiles:
            run_hooks(
                config.hooks, "after", "deploy", cwd=profile_cwd(name), dry_run=dry_run
            )

    # ruff: disable[RUF001]
    cat = (
        "[green]"
        + """
  ／l、
 (˚ˎ 。７
  l  ~ \\
  じしf_,)ノ
    """
        + "[/]"
    )
    message = (
        "[green]"
        + """
 ┌            ┌┬
┌┤┬┐┌┐│┌┐┐┌┬┐┌┤│
││├┘│││││││├┘││┴
└┘┴┘├┘└└┘└┤┴┘└┘"
    └    ─┘
       """
        + "[/]"
    )
    # ruff: enable[RUF001]

    table = Table("cat", "msg", show_header=False, box=None)
    table.add_row(cat, message)
    console.print(table)
