from collections import deque
from collections.abc import Iterator
from contextlib import contextmanager

from rich.console import Group
from rich.live import Live
from rich.panel import Panel
from rich.progress import Progress, ProgressColumn, SpinnerColumn, Task, TextColumn
from rich.text import Text

FULL = "⣿"
HALF = "⡇"
EMPTY = "⠀"


class BrailleBarColumn(ProgressColumn):
    """A progress bar drawn with braille cells."""

    def __init__(
        self,
        bar_width: int = 40,
        complete_style: str = "bar.complete",
        back_style: str = "bar.back",
        finished_style: str = "bar.finished",
    ) -> None:
        """Initialize."""
        self.bar_width = bar_width
        self.complete_style = complete_style
        self.back_style = back_style
        self.finished_style = finished_style
        super().__init__()

    def render(self, task: Task) -> Text:
        """Render the bar."""
        steps = self.bar_width * 2
        filled = max(0, min(steps, round(steps * task.percentage / 100)))
        full, half = divmod(filled, 2)

        complete = self.finished_style if task.finished else self.complete_style
        bar = Text(FULL * full, style=complete)
        if half:
            bar.append(HALF, style=complete)

        bar.append(EMPTY * (self.bar_width - full - half), style=self.back_style)
        return bar


def make_progress(*, transient: bool = True, bar_width: int = 5) -> Progress:
    """A Progress with a spinner, description, and the braille bar."""
    return Progress(
        SpinnerColumn(),
        BrailleBarColumn(bar_width=bar_width),
        TextColumn("[progress.description]{task.description}"),
        transient=transient,
    )


class LogWindow:
    """A height-limited tail of recent log lines."""

    def __init__(self, height: int = 8, style: str = "dim") -> None:
        """Initialize an empty window that keeps at most `height` lines."""
        self.height = height
        self.style = style
        self.lines: deque[str] = deque(maxlen=height)

    def write(self, line: str) -> None:
        """Append a line, dropping the oldest once the window is full."""
        self.lines.append(line)

    def clear(self) -> None:
        """Empty the window between steps so consecutive outputs don't mix."""
        self.lines.clear()

    def __rich__(self) -> Panel:
        """Render the tail as a boxed, fixed-height block, newest line at the bottom."""
        padded = [""] * (self.height - len(self.lines)) + list(self.lines)
        body = Text(
            "\n".join(padded), style=self.style, no_wrap=True, overflow="ellipsis"
        )

        return Panel(body, padding=(0, 1))


@contextmanager
def live_progress(
    *, height: int = 8, bar_width: int = 5, transient: bool = True
) -> Iterator[tuple[LogWindow, Progress]]:
    """A Live showing a height-limited log window above a braille progress bar."""
    window = LogWindow(height)
    progress = make_progress(transient=transient, bar_width=bar_width)

    with Live(Group(window, progress), transient=transient, refresh_per_second=12):
        yield window, progress
