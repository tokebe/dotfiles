import shlex
import subprocess
import threading
import time
from collections.abc import Callable
from pathlib import Path

from rich.console import Console

from dot.types.shared import REPO_ROOT
from dot.types.software import PACKAGE_MANAGERS, PackageAdapter, PackageManagers
from dot.utils.progress import live_progress
from dot.utils.symbols import NEUTRAL

Sink = Callable[[str], None]  # receives each output line as it streams

console = Console()

STEP_PAUSE = 0.5  # If a refresh produces output, hold long enough for the eye to register


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
        assert process.stdout is not None

        # Drain stderr on a thread so a large stdout can't fill its pipe and deadlock
        def _drain_stderr() -> None:
            assert process.stderr is not None
            for raw in process.stderr:
                if sink:
                    sink(raw.rstrip("\n"))

        thread = threading.Thread(target=_drain_stderr)
        thread.start()
        stdout = process.stdout.read()
        thread.join()
        process.wait()
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
    """Sync all package indices once, isolating per-manager refresh failures."""
    adapters = get_enabled_managers()
    if managers is not None:
        adapters = {n: a for n, a in adapters.items() if n in managers}

    refreshable = {n: a for n, a in adapters.items() if a.refresh}

    if dry_run:
        for adapter in refreshable.values():
            console.print(adapter.refresh)
        return

    with live_progress(bar_width=len(refreshable)) as (window, progress):
        task = progress.add_task("Refreshing indices", total=len(refreshable))
        for name, adapter in refreshable.items():
            window.clear()
            progress.update(task, description=f"Refreshing indices ({name})")
            try:
                refresh(adapter, window.write)
            except subprocess.CalledProcessError as err:
                console.print(
                    f"[yellow]{NEUTRAL} {name} refresh failed (exit {err.returncode}), continuing...[/]"
                )
            progress.advance(task)

            if window.lines:
                time.sleep(STEP_PAUSE)


def check_updates(adapter: PackageAdapter, sink: Sink | None = None) -> int:
    """Count of available updates.

    `check` prints a bare integer on stdout, progress on stderr; non-integer output counts as 0.
    """
    out = run_stream(adapter.check, sink, split=True).stdout.strip()
    last = out.splitlines()[-1].strip() if out else ""
    try:
        return int(last)
    except ValueError:
        return 0


def installed_packages(adapter: PackageAdapter) -> set[str]:
    """Names the manager reports installed."""
    if not adapter.list_installed:
        return set()

    out = run(adapter.list_installed, capture=True).stdout
    return {line.strip() for line in out.splitlines() if line.strip()}


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


def get_enabled_managers() -> PackageManagers:
    """Get the presently-enabled adapters, detected fresh each call.

    Not cached: managers installed mid-run (nvm node, brew pnpm) must become visible.
    """
    return {
        name: adapter for name, adapter in PACKAGE_MANAGERS.items() if detect(adapter)
    }
