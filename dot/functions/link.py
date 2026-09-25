import functools
import os
import shutil
import subprocess
from collections.abc import Iterator
from pathlib import Path
from typing import Literal

from InquirerPy import inquirer
from rich.console import Console

from dot.types.config import CleanRule, Config, CreateRule, Link
from dot.utils.dispatch import REPO_ROOT
from dot.utils.hooks import run_hooks
from dot.utils.profile import ActiveProfiles, profile_cwd
from dot.utils.symbols import FAIL, NEUTRAL, OK

console = Console()


Phases = set[Literal["create", "clean", "link"]]


def run_link(
    active_profiles: ActiveProfiles,
    *,
    phases: Phases | None = None,
    dry_run: bool = False,
    suppress_hooks: bool = False,
) -> None:
    """Create dirs, prune dead repo links, and apply link rules for the active profiles."""
    # If phases not set, run all
    if not phases:
        phases = {"create", "clean", "link"}

    if not suppress_hooks:
        for name, config in active_profiles:
            run_hooks(
                config.hooks, "before", "link", cwd=profile_cwd(name), dry_run=dry_run
            )

    # create/clean per profile
    for _name, config in active_profiles:
        _apply_profile_phase(config, phases=phases, dry_run=dry_run)
    if "link" in phases:  # link requires special merging
        _link(active_profiles, dry_run=dry_run)

    if not suppress_hooks:
        for name, config in active_profiles:
            run_hooks(
                config.hooks, "after", "link", cwd=profile_cwd(name), dry_run=dry_run
            )


def _apply_profile_phase(
    config: Config, *, phases: Phases, dry_run: bool = False
) -> None:
    """Apply a profile's create/clean."""
    if "create" in phases:
        _create(config.create, dry_run=dry_run)

    if "clean" in phases:
        _clean(config.clean, dry_run=dry_run)


def _create(entries: list[Path | CreateRule], *, dry_run: bool = False) -> None:
    """Ensure configured directories exists.

    Reports status. Mode defaults to 0777).
    """
    for entry in entries:
        rule = entry if isinstance(entry, CreateRule) else CreateRule(dir=entry)
        path = rule.dir.expanduser()

        if path.exists():
            console.print(f"{NEUTRAL} EXISTS {path}")
            continue

        if dry_run:
            console.print(f"[PLANNED] CREATE {path} (mode {rule.mode:04o})")
            continue

        try:
            path.mkdir(parents=True)
            path.chmod(rule.mode)
        except OSError as error:
            console.print(f"{FAIL} CREATE {path}: {error}")
        else:
            console.print(f"{OK} CREATE {path}")


def _clean(entries: list[Path | CleanRule], *, dry_run: bool = False) -> None:
    """Prune dead symlinks in each configured directory.

    Rule defines via `force` whether to clean all symlinks
    or only those pointing into the repo.
    """
    for entry in entries:
        rule = entry if isinstance(entry, CleanRule) else CleanRule(dir=entry)
        directory = rule.dir.expanduser()
        if not directory.is_dir():
            continue

        for path in _sweep(directory, recursive=rule.recursive):
            if not _is_dead_link(path, force=rule.force):
                continue

            src = path.readlink()
            message = f"CLEAN {path}   [dim]{src} 󰮘 [/]"
            done = "[green] [/] "

            if dry_run:
                console.print(f"[PLANNED] {message}")
                continue

            try:
                path.unlink()
            except OSError as error:
                console.print(f"{FAIL} CLEAN {path}: {error}")
            else:
                console.print(done + message)


def _sweep(directory: Path, *, recursive: bool) -> Iterator[Path]:
    """Yield entries in a directory."""
    if not recursive:
        yield from directory.iterdir()
        return

    for root, dirs, files in os.walk(
        directory, followlinks=False
    ):  # Don't descend symlinks
        for name in (*dirs, *files):
            yield Path(root) / name


def _is_dead_link(path: Path, *, force: bool = False) -> bool:
    """Check if path is a broken symlink.

    Unless force, only count those which resolve to the repo.
    """
    if not path.is_symlink() or path.exists():
        return False

    return force or path.resolve().is_relative_to(REPO_ROOT)


def _link(active_profiles: ActiveProfiles, *, dry_run: bool = False) -> None:
    """Apply the merged link set."""
    # Check if user can tolerate unsafe deletion (a dry run deletes nothing, so don't ask)
    unsafe_delete = False
    if not dry_run and not _has_gtrash():
        unsafe_delete = inquirer.confirm(
            "Gtrash not present, use permanent deletion?", default=False
        ).execute()

    for dest, (src, force) in _merge_link_configs(active_profiles).items():
        _make_link(dest, src, force=force, dry_run=dry_run, unsafe_delete=unsafe_delete)


def _merge_link_configs(
    active_profiles: ActiveProfiles,
) -> dict[Path, tuple[Path, bool]]:
    """Merge every profile's links into target -> (source, force).

    Last active profile wins per resolved target.
    """
    merged: dict[Path, tuple[Path, bool]] = {}

    for name, config in active_profiles:
        root = profile_cwd(name) or REPO_ROOT
        for target, value in config.links.items():
            src = str(value.src) if isinstance(value, Link) else value
            if isinstance(value, Link) and value.force is not None:
                force = value.force
            else:
                force = config.force_links
            dest = Path(target).expanduser()

            if "*" not in src:
                merged[dest] = (root / src, force)
                continue

            matches = sorted(root.glob(src))
            if not matches:
                console.print(f"{FAIL} LINK {dest}: no sources match {root / src}")
            for match in matches:
                merged[dest / match.name] = (match, force)

    return merged


def _make_link(
    dest: Path,
    src: Path,
    *,
    force: bool,
    dry_run: bool = False,
    unsafe_delete: bool = False,
) -> None:
    """Point dest at src.

    By default, skips if already linked or file. Force overwrites.
    """
    if not src.exists():
        console.print(f"{FAIL} LINK {dest}: missing source {src}")
        return
    if dest.is_symlink() and dest.readlink() == src:
        console.print(f"{NEUTRAL} LINK {dest}   [dim]{src}[/]")
        return

    if dry_run:
        console.print(f"[PLANNED] LINK {dest}   [dim]{src}[/]")
        return

    occupied = dest.is_symlink() or dest.exists()
    if occupied and not force:
        console.print(f"{FAIL} LINK {dest}: target exists")
        return

    try:
        if occupied and not _remove(dest, unsafe_delete):
            console.print(f"{FAIL} LINK {dest}: original kept")
            return
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.symlink_to(src)
    except (OSError, subprocess.CalledProcessError) as error:
        console.print(f"{FAIL} LINK {dest}: {error}")
    else:
        console.print(f"{OK} LINK {dest}   [dim]{src}[/]")


@functools.lru_cache
def _has_gtrash() -> bool:
    """Check if the system has gtrash."""
    return bool(shutil.which("gtrash"))


def _remove(dest: Path, unsafe_delete: bool = False) -> bool:
    """Unlink a symlink or trash a file.

    Returns:
        Removal success
    """
    if dest.is_symlink():
        dest.unlink()
        return True

    if _has_gtrash():
        subprocess.run(["gtrash", "put", "--", str(dest)], check=True)
        return True

    if not unsafe_delete:
        return False

    if dest.is_dir():
        shutil.rmtree(dest)
    else:
        dest.unlink()
    return True
