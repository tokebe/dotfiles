import functools
import shlex
import subprocess
from collections.abc import Callable
from pathlib import Path

from rich.console import Console

from dot.types.software import PACKAGE_MANAGERS, PackageAdapter, PackageManagers

REPO_ROOT = Path(__file__).resolve().parents[2]

Sink = Callable[[str], None]  # receives each output line as it streams

console = Console()


def insert_packages(template: str, packages: list[str]) -> str:
    """Substitute shell-quoted package names into a command's `{packages}` placeholder."""
    joined = " ".join(shlex.quote(p) for p in packages)
    return template.replace("{packages}", joined)


def run(
    command: str, *, capture: bool = False, cwd: Path | None = None
) -> subprocess.CompletedProcess[str]:
    """Run a bash command in cwd.

    Without capture it inherits the TTY.
    """
    return subprocess.run(
        ["bash", "-c", command],
        cwd=cwd or REPO_ROOT,
        text=True,
        capture_output=capture,
        check=False,
    )


def run_stream(
    command: str,
    sink: Sink | None = None,
    *,
    split: bool = False,
    cwd: Path | None = None,
) -> subprocess.CompletedProcess[str]:
    """Run a bash command in cwd, streaming output to `sink`.

    With `split`, stderr streams to `sink` while stdout is captured and returned (for a
    small machine-readable result); otherwise stderr is merged into the streamed stdout.
    """
    process = subprocess.Popen(
        ["bash", "-c", command],
        cwd=cwd or REPO_ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE if split else subprocess.STDOUT,
        bufsize=1,
    )

    if split:
        assert process.stderr is not None
        for raw in process.stderr:
            if sink:
                sink(raw.rstrip("\n"))

        stdout, _ = process.communicate()
        return subprocess.CompletedProcess(command, process.returncode, stdout, "")

    lines: list[str] = []
    assert process.stdout is not None
    for raw in process.stdout:
        line = raw.rstrip("\n")
        lines.append(line)
        if sink:
            sink(line)

    return subprocess.CompletedProcess(command, process.wait(), "\n".join(lines), "")


def detect(adapter: PackageAdapter) -> bool:
    """Whether the manager is present."""
    return run(adapter.detect, capture=True).returncode == 0


def refresh(adapter: PackageAdapter, sink: Sink | None = None) -> None:
    """Sync one manager's package index if it defines a refresh command."""
    if adapter.refresh:
        run_stream(adapter.refresh, sink).check_returncode()


def refresh_all(managers: list[str] | None = None, *, dry_run: bool = False) -> None:
    """Sync all package indices once."""
    adapters = get_enabled_managers()
    if managers is not None:
        adapters = {n: a for n, a in adapters.items() if n in managers}

    for adapter in adapters.values():
        if not adapter.refresh:
            continue
        if dry_run:
            console.print(adapter.refresh)
        else:
            refresh(adapter)


def check_updates(adapter: PackageAdapter, sink: Sink | None = None) -> int:
    """Count of available updates.

    `check` prints a bare integer on stdout, progress on stderr.
    """
    out = run_stream(adapter.check, sink, split=True).stdout.strip()
    return int(out or 0)


def install_packages(
    adapter: PackageAdapter, packages: list[str], *, dry_run: bool = False
) -> None:
    """Install/sync the given packages, streaming output so progress is visible."""
    command = insert_packages(adapter.install, packages)

    if dry_run:
        console.print(command)
        return

    run(command).check_returncode()


def try_install_package(
    adapter: PackageAdapter, packages: list[str]
) -> subprocess.CompletedProcess[str]:
    """Attempt an install with output captured.

    Returns:
        The completed process for inspection.
    """
    return run(insert_packages(adapter.install, packages), capture=True)


def upgrade_packages(adapter: PackageAdapter, *, dry_run: bool = False) -> None:
    """Upgrade everything the manager tracks, streaming output."""
    if dry_run:
        console.print(adapter.upgrade)
        return

    run(adapter.upgrade).check_returncode()


@functools.lru_cache
def get_enabled_managers() -> PackageManagers:
    """Get the presently-enabled adapters."""
    return {
        name: adapter for name, adapter in PACKAGE_MANAGERS.items() if detect(adapter)
    }
