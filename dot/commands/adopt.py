import shutil
from pathlib import Path
from typing import Annotated

import tomlkit
import typer
from rich.console import Console
from rich.markup import escape

from dot.types.config import CONFIG, Config, Link
from dot.utils.dispatch import REPO_ROOT
from dot.utils.profile import get_available_profiles, profile_cwd
from dot.utils.symbols import FAIL, OK

console = Console()

app = typer.Typer(
    context_settings={"help_option_names": ["-h", "--help"]},
)


@app.command(name="adopt | a")
def adopt(
    src: Annotated[Path, typer.Argument(help="Existing real path to adopt.")],
    dest: Annotated[
        Path,
        typer.Argument(help="Home in the repo."),
    ],
    profile: Annotated[
        str | None,
        typer.Option("--profile", "-p", help="Profile to configure link with."),
    ] = None,
    dry_run: Annotated[
        bool, typer.Option("--dryrun", "-d", help="Do a dry run.")
    ] = False,
) -> None:
    """Adopt a path into the repo and symlink it."""
    # absolute() not resolve(): keep src's own symlink identity for the check below
    src = src.expanduser().absolute()
    if not src.exists():
        console.print(f"[red]{FAIL} {src} does not exist[/]")
        raise typer.Exit(1)

    if src.is_symlink() and src.resolve().is_relative_to(REPO_ROOT):
        console.print(f"[red]{FAIL} {src} is already adopted[/]")
        raise typer.Exit(1)

    dest, profile, profile_rootdir = _resolve_target(dest, profile)

    if dest.exists() or dest.is_symlink():
        console.print(f"[red]{FAIL} {dest} already exists in the repo[/]")
        raise typer.Exit(1)

    # Move the real path into the repo, then leave a symlink where it was
    if dry_run:
        console.print(f"[PLANNED] ADOPT {src} 󰪹  {dest}")
    else:
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(src, dest)
        src.symlink_to(dest)
        console.print(f"{OK} ADOPT {src} 󰪹  [dim] {dest}[/]")

    # Check the base plus the chosen profile
    configs: list[tuple[Config, Path]] = [(CONFIG, REPO_ROOT)]
    if profile != "DEFAULT":
        configs.append((get_available_profiles()[profile], profile_rootdir))

    if _rule_covers(src, dest, configs):
        console.print(f"{OK} Already covered by an existing link rule")
    else:
        _add_link_rule(src, dest, profile_rootdir, dry_run=dry_run)

    if not dry_run:
        console.print(f"{OK} Adopt complete!")


def _resolve_target(dest: Path, profile: str | None) -> tuple[Path, str, Path]:
    """Resolve dest relative to the repo and the profile that owns it."""
    dest = (REPO_ROOT / dest).resolve()
    if not dest.is_relative_to(REPO_ROOT):
        console.print(f"[red]{FAIL} {dest} is outside the repo[/]")
        raise typer.Exit(1)

    profiles = get_available_profiles()
    if profile is not None:
        if profile.lower() == "default":
            profile = "DEFAULT"
        elif profile not in profiles:
            console.print(f"[red]{FAIL} Profile {profile} not found[/]")
            raise typer.Exit(1)
    else:
        profile = next(
            (
                name
                for name in profiles
                if (cwd := profile_cwd(name)) and dest.is_relative_to(cwd)
            ),
            "DEFAULT",
        )

    return dest, profile, profile_cwd(profile) or REPO_ROOT


def _add_link_rule(
    src: Path, dest: Path, profile_rootdir: Path, *, dry_run: bool = False
) -> None:
    """Write a `target = source` link rule into the owning profile's CONFIG.toml."""
    target = _home_str(src)
    source = str(dest.relative_to(profile_rootdir))
    config_path = profile_rootdir / "CONFIG.toml"
    rel = config_path.relative_to(REPO_ROOT)

    doc = tomlkit.parse(config_path.read_text())
    if "links" not in doc:
        doc["links"] = tomlkit.table()
    doc["links"][target] = source
    text = tomlkit.dumps(doc)

    if dry_run:
        console.print(f'[PLANNED] RULE {rel}: "{target}" = "{source}"')
    else:
        config_path.write_text(text)
        console.print(f'{OK} RULE {rel}: "{target}" = "{source}"')

    _preview(text, target)


def _preview(text: str, key: str, buffer: int = 2) -> None:
    """Preview the added rule in context."""
    lines = text.splitlines()
    idx = next(
        (i for i, line in enumerate(lines) if line.strip().startswith(f'"{key}"')),
        None,
    )
    if idx is None:
        return

    for line in lines[max(0, idx - buffer) : idx + buffer + 1]:
        console.print(f"[dim]  │ {escape(line)}[/]")


def _home_str(path: Path) -> str:
    """Render an absolute path with a `~` prefix when it lives under home."""
    home = Path.home()
    if not path.is_relative_to(home):
        return str(path)

    rel = path.relative_to(home)
    return "~" if str(rel) == "." else f"~/{rel}"


def _rule_covers(src: Path, dest: Path, configs: list[tuple[Config, Path]]) -> bool:
    """Whether an existing link rule already maps target `src` to source `dest`."""
    for config, root in configs:
        for target, value in config.links.items():
            source = str(value.src) if isinstance(value, Link) else value
            target_path = Path(target).expanduser()

            if "*" not in source:
                # A direct rule covers dest when its source is dest or an ancestor folder
                source_resolved = (root / source).resolve()
                if (
                    dest.is_relative_to(source_resolved)
                    and target_path / dest.relative_to(source_resolved) == src
                ):
                    return True
                continue

            # A glob covers dest when dest or a containing folder matches the pattern
            for ancestor in (dest, *dest.parents):
                if not ancestor.is_relative_to(root):
                    break
                if ancestor.relative_to(root).full_match(source):
                    if target_path / ancestor.name / dest.relative_to(ancestor) == src:
                        return True
                    break

    return False
