import tomllib
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field

BASE_CONFIG_PATH = Path("CONFIG.toml")

EventName = str
HookMode = Literal["silent", "auto", "verbose", "interactive"]


class CreateRule(BaseModel):
    """Rule governing a directory creation."""

    dir: Path
    mode: int = 0o777


class ProfileWhen(BaseModel):
    """Filter for selecting if a profile should be active; a list matches any of its values."""

    os: str | list[str] | None = None
    distro: str | list[str] | None = None
    architecture: str | list[str] | None = None
    host: str | list[str] | None = None
    desktop: bool | str | list[bool | str] | None = None
    cond: str | None = None


class Profile(BaseModel):
    """Profile-specifc config."""

    priority: int = 10
    when: ProfileWhen


class Link(BaseModel):
    """Information about an intended symlink."""

    src: Path
    force: bool | None = Field(
        default=None,
        description="Overwrite existing files/links; None inherits force_links",
    )


class CleanRule(BaseModel):
    """A rule governing cleaning of symlinks from a directory."""

    dir: Path
    recursive: bool = False
    force: bool = Field(
        default=False, description="Also prune dead symlinks pointing outside the repo"
    )


class Hook(BaseModel):
    """A scripting hook."""

    name: str
    command: str
    mode: HookMode = "auto"


class HookSet(BaseModel):
    """A set of hooks defining when to fire relative to an event."""

    before: dict[EventName, list[Hook]] = Field(default_factory=dict)
    after: dict[EventName, list[Hook]] = Field(default_factory=dict)

    def get(self, timing: Literal["before", "after"]) -> dict[EventName, list[Hook]]:
        """Get a set by timing str."""
        if timing == "before":
            return self.before
        else:
            return self.after


class Config(BaseModel):
    """Global config."""

    create: list[Path | CreateRule] = Field(default_factory=list)
    clean: list[Path | CleanRule] = Field(default_factory=list)
    force_links: bool = False
    links: dict[str, str | Link] = Field(default_factory=dict)
    hooks: HookSet = Field(default_factory=HookSet)


class ProfileConfig(Config):
    """Profile-specific config."""

    profile: Profile


with BASE_CONFIG_PATH.open("rb") as file:
    CONFIG = Config.model_validate(tomllib.load(file))
