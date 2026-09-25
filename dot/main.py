import re
from re import Pattern
from typing import Any, override

import typer
from rich.console import Console
from typer._click import Command, Context
from typer.core import TyperGroup

from dot.commands.add_profile import app as add_profile_app
from dot.commands.adopt import app as adopt_app
from dot.commands.deploy import app as deploy_app
from dot.commands.hook import app as hook_app
from dot.commands.install import app as install_app
from dot.commands.link import app as link_app
from dot.commands.update import app as update_app
from dot.utils.symbols import FAIL

console = Console(stderr=True)


class AliasGroup(TyperGroup):
    """Special AliasGroup that allows typer commands to have aliases."""

    _CMD_SPLIT_P: Pattern[str] = re.compile(r" ?[,|] ?")

    @override
    def get_command(self, ctx: Context, cmd_name: str) -> Command | None:
        """Get a command given the name."""
        cmd_name = self._group_cmd_name(default_name=cmd_name)
        return super().get_command(ctx, cmd_name)

    @override
    def invoke(self, ctx: Context) -> Any:
        """Invoke a command, reporting a clean cancel on Ctrl-C."""
        try:
            return super().invoke(ctx)
        except KeyboardInterrupt:
            console.print(f"[red]{FAIL} Canceled.[/]")
            raise SystemExit(130) from None

    def _group_cmd_name(self, default_name: str) -> str:
        for cmd in self.commands.values():
            name = cmd.name
            if name and default_name in self._CMD_SPLIT_P.split(name):
                return name
        return default_name


app = typer.Typer(
    cls=AliasGroup,
    no_args_is_help=True,
    context_settings={"help_option_names": ["-h", "--help"]},
    help="Custom dotfile management scripts for an eclectic system.",
)

app.add_typer(deploy_app)
app.add_typer(link_app)
app.add_typer(adopt_app)
app.add_typer(add_profile_app)
app.add_typer(install_app)
app.add_typer(update_app)
app.add_typer(hook_app)


def main() -> None:
    """Run the Typer App."""
    app()


if __name__ == "__main__":
    main()
