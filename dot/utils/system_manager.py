from collections.abc import Callable

from dot.types.software import PackageAdapter, PackageManagers
from dot.utils.dispatch import detect

FALLBACK = "*"


def resolve_system_manager(
    managers: PackageManagers,
    *,
    os: str,
    distro: str | None = None,
    detect: Callable[[PackageAdapter], bool] = detect,
) -> tuple[str, PackageAdapter] | None:
    """Pick the native system manager, else the `*` fallback."""
    candidates = {
        name: adapter
        for name, adapter in managers.items()
        if adapter.native_on and detect(adapter)
    }
    if not candidates:
        return None

    facts = {os.lower(), (distro or "").lower()}

    for name, adapter in candidates.items():
        if facts & {d.lower() for d in adapter.native_on}:
            return name, adapter

    for name, adapter in candidates.items():
        if FALLBACK in adapter.native_on:
            return name, adapter

    return None
