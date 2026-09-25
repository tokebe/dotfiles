from typing import Annotated

import typer
from rich.console import Console

from dot.utils.profile import PROFILES_DIR
from dot.utils.symbols import FAIL, NEUTRAL, OK

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)

console = Console()

CONFIG_TEMPLATE = """\
[profile]
priority = 10
# TODO add activation conditions (os, distro, architecture, host, desktop, cond)
when = {}

# [[create]]
# dir = "~/Something"
# mode = "0777"

# [[clean]]
# dir = "~/Something"
# recursive = false

# [links]
# "~/Something" = "<something_src>"

[[hooks.before.deploy]]
name = "You forgot to customize profile {PROFILE_NAME}"
command = "! :"
mode = "silent"
"""

SOFTWARE_TEMPLATE = "# Software for this profile (see root SOFTWARE.toml).\n"


@app.command(name="add-profile | ap")
def add_profile(
    name: Annotated[str, typer.Argument(help="Name for the new profile.")],
) -> None:
    """Boilerplate a new profile under profiles/<name>/."""
    if name.lower() == "default":
        console.print(f"[red]{FAIL} {name!r} is reserved for the root profile[/]")
        return
    if "/" in name or name in {"", ".", ".."}:
        console.print(f"[red]{FAIL} Invalid profile name: {name!r}[/]")
        return

    profile_dir = PROFILES_DIR / name
    if profile_dir.exists():
        console.print(
            f"[yellow]{NEUTRAL} Profile {name} already exists at {profile_dir}[/]"
        )
        return

    (profile_dir / "linked").mkdir(parents=True)
    (profile_dir / "scripts").mkdir(parents=True)
    (profile_dir / "CONFIG.toml").write_text(
        CONFIG_TEMPLATE.replace("PROFILE_NAME", name)
    )
    (profile_dir / "SOFTWARE.toml").write_text(SOFTWARE_TEMPLATE)

    console.print(f"[green]{OK} Created profile {name} at {profile_dir}[/]")
