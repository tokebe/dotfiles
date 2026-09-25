import tomllib
from pathlib import Path

from pydantic import BaseModel, TypeAdapter

from dot.types.shared import Distro

BASE_SOFTWARE_PATH = Path("SOFTWARE.toml")
PACKAGE_MANAGERS_PATH = Path("PACKAGE_MANAGERS.toml")

PackageManagerName = str
PackageName = str

SoftwareEntry = (
    PackageName | list[PackageName] | dict[Distro, PackageName | list[PackageName]]
)

Software = dict[PackageManagerName, list[SoftwareEntry]]


class PackageAdapter(BaseModel):
    """An adapter which defines standardized interactions with a given package manager."""

    native_on: list[str] = []
    refresh: str | None = None
    detect: str
    install: str
    upgrade: str
    check: str


PackageManagers = dict[PackageManagerName, PackageAdapter]


with BASE_SOFTWARE_PATH.open("rb") as file:
    SOFTWARE = TypeAdapter(Software).validate_python(tomllib.load(file))

with PACKAGE_MANAGERS_PATH.open("rb") as file:
    PACKAGE_MANAGERS = TypeAdapter(PackageManagers).validate_python(tomllib.load(file))
