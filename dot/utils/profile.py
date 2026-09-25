import functools
import os
import platform
import socket
import tomllib
from dataclasses import dataclass
from pathlib import Path

import distro
from pydantic import TypeAdapter
from rich.console import Console

from dot.types.config import CONFIG, Config, ProfileConfig, ProfileWhen
from dot.types.software import SOFTWARE, Software
from dot.utils.dispatch import REPO_ROOT, run

PROFILES_DIR = Path("profiles")

ActiveProfiles = list[tuple[str, Config]]

console = Console()

### System discovery


@dataclass(frozen=True)
class System:
    """System information for profile selection."""

    os: str
    distro: str | None
    architecture: str
    host: str
    desktop: bool | str


@functools.lru_cache
def detect_system() -> System:
    """Return system information (cached; facts don't change during a run)."""
    os_name = {"darwin": "macos"}.get(
        platform.system().lower(), platform.system().lower()
    )

    return System(
        os=os_name,
        distro=_distro(os_name),
        architecture=platform.machine().lower(),
        host=(platform.node() or socket.gethostname()).split(".")[0],
        desktop=_desktop(os_name),
    )


def _distro(os_name: str) -> str | None:
    """Resolve current distro."""
    if os_name == "macos":  # MacOS is its own distro
        return "macos"

    return distro.id() or None


def _desktop(os_name: str) -> bool | str:
    """Get the desktop environment name or status.

    Returns:
        The desktop name, or True for a bare graphical session, else False.
    """
    if os_name == "macos":
        return "aqua"

    de = os.environ.get("XDG_CURRENT_DESKTOP") or os.environ.get("DESKTOP_SESSION")
    if de:
        return de.split(":")[0].lower()

    return bool(os.environ.get("WAYLAND_DISPLAY") or os.environ.get("DISPLAY"))


### Profile resolution


def profile_cwd(name: str) -> Path | None:
    """Get the base dir for the a profile."""
    return None if name == "DEFAULT" else REPO_ROOT / PROFILES_DIR / name


def resolve_active(forced: list[str] | None = None) -> ActiveProfiles:
    """Resolve the active profiles and announce them."""
    active = resolve_profiles(forced)
    console.print(f"Active profiles: {', '.join(name for name, _ in active)}")
    return active


def resolve_profiles(
    pre_selected: list[str] | None = None,
) -> ActiveProfiles:
    """Get active profiles.

    Returns:
        root DEFAULT first, then profiles by priority.
    """
    profiles = get_available_profiles()

    selected: ActiveProfiles
    if pre_selected:
        selected = []
        for name in pre_selected:
            if name.lower() == "default":
                continue  # the default profile is always included below
            if name in profiles:
                selected.append((name, profiles[name]))
            else:
                console.print(f"[yellow]Profile {name} not found, skipping...[/]")
    else:
        facts = detect_system()
        selected = [
            (name, config)
            for name, config in profiles.items()
            if _matches(config.profile.when, facts)
        ]

    ordered = sorted(selected, key=lambda entry: profiles[entry[0]].profile.priority)
    return [("DEFAULT", CONFIG), *ordered]


def merge_software(profiles: ActiveProfiles) -> Software:
    """Merge SOFTWARE lists between profiles."""
    merged: Software = {}

    for profile in (SOFTWARE, *(_get_profile_software(name) for name, _ in profiles)):
        for manager, entries in profile.items():
            merged.setdefault(manager, []).extend(entries)

    return merged


def _get_profile_software(name: str) -> Software:
    """Load profiles/<name>/SOFTWARE.toml."""
    path = PROFILES_DIR / name / "SOFTWARE.toml"
    if not path.is_file():
        return {}  # Return empty if not present

    with path.open("rb") as file:
        return TypeAdapter(Software).validate_python(tomllib.load(file))


@functools.lru_cache
def get_available_profiles() -> dict[str, ProfileConfig]:
    """Load every profiles/<name>/CONFIG.toml, keyed by directory name."""
    profiles: dict[str, ProfileConfig] = {}
    if not PROFILES_DIR.is_dir():
        return profiles

    for path in sorted(PROFILES_DIR.glob("*/CONFIG.toml")):
        with path.open("rb") as file:
            profiles[path.parent.name] = ProfileConfig.model_validate(
                tomllib.load(file)
            )

    return profiles


def _matches(when: ProfileWhen, system: System) -> bool:
    """Whether `when` matches the machine."""
    if when.cond is not None:  # Cond takes precedence
        siblings = (when.os, when.distro, when.architecture, when.host, when.desktop)
        if any(key is not None for key in siblings):
            console.print("[yellow]`cond` overrides the other `when` keys[/]")
        return run(when.cond, capture=True).returncode == 0

    for want, have in (
        (when.os, system.os),
        (when.distro, system.distro),
        (when.architecture, system.architecture),
        (when.host, system.host),
    ):
        if want is not None and not _fact_matches(want, have):
            return False

    return when.desktop is None or _desktop_matches(when.desktop, system.desktop)


def _fact_matches(want: str | list[str], have: str | None) -> bool:
    """Check that fact matches.

    Lists are used as ALLOW.
    """
    if isinstance(want, list):
        return have in want
    return have == want


def _desktop_matches(want: bool | str | list[bool | str], have: bool | str) -> bool:
    """Check if desktop preference matches."""
    if isinstance(want, list):  # List is ALLOW
        return any(_desktop_matches(option, have) for option in want)

    if isinstance(want, bool):  # Bool means ANY (not none)
        return bool(have) == want

    return isinstance(have, str) and have.lower() == want.lower()
