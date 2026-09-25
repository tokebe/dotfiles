from pathlib import Path
from typing import Literal

from rich.console import Console, Group
from rich.live import Live
from rich.spinner import Spinner
from rich.text import Text

from dot.types.config import EventName, Hook, HookSet
from dot.utils.dispatch import run, run_stream
from dot.utils.progress import LogWindow
from dot.utils.symbols import FAIL, OK, SILENT

console = Console()


def run_hook(
    hook: Hook,
    timing: Literal["before", "after"],
    *,
    cwd: Path | None = None,
    dryrun: bool = False,
) -> bool:
    """Run a hook with spinner and handle output.

    Returns:
        Whether hook exited with code 0 (success).
    """
    label = "Prehook" if timing == "before" else "Posthook"

    if dryrun:
        console.print(
            f"[bright_black]\\[{label}] {hook.name}: {hook.command}{' 󰝟 ' if hook.mode == 'silent' else ''}[/]"
        )
        return True

    if hook.mode == "interactive":
        # Run in real terminal so interactivity works
        console.print(f"{hook.name}...")
        ok = run(hook.command, cwd=cwd).returncode == 0
        console.print(f"{OK if ok else FAIL} \\[{label}] {hook.name}")
        return ok

    window = LogWindow() if hook.mode != "silent" else None
    spinner = Spinner(
        "dots",
        text=Text(f"{hook.name}{f'{SILENT} ' if hook.mode == 'silent' else ''}..."),
    )
    group = Group(window, spinner) if window else Group(spinner)

    with Live(group, console=console, transient=True, refresh_per_second=12):
        result = run_stream(hook.command, window.write if window else None, cwd=cwd)

    ok = result.returncode == 0
    keep_output = hook.mode == "verbose" or (hook.mode == "auto" and not ok)
    output = result.stdout.strip()

    if keep_output and output:
        console.rule(f"[bold]{hook.name}[/]", align="right")
        console.print(output)

    completion_msg = f"{OK if ok else FAIL} \\[{label}] {hook.name}{f' {SILENT}' if hook.mode == 'silent' else ''}"
    if keep_output and output:
        console.rule(completion_msg, align="left")
    else:
        console.print(completion_msg)
    return ok


def run_hooks(
    hooks: HookSet,
    timing: Literal["before", "after"],
    event: EventName,
    *,
    cwd: Path | None = None,
    dry_run: bool = False,
) -> None:
    """Run the hooks bound to a timing/event, in listed order, from `cwd`."""
    for hook in hooks.get(timing).get(event, []):
        run_hook(hook, timing, cwd=cwd, dryrun=dry_run)
