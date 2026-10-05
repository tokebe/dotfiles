#!/usr/bin/env python3
# Adapted from gvolpe's nfsm daemon: https://github.com/gvolpe/nfsm
# pyright: reportAny=false
# pyright: reportExplicitAny=false

from dataclasses import dataclass
import json
import re
import subprocess
from subprocess import CompletedProcess
import sys
import threading
from time import sleep
import traceback
from typing import Any, Callable, NamedTuple, TypedDict

FieldDict = TypedDict(
    "FieldDict",
    {
        "outputs": dict[str, Any],
        "workspaces": dict[str, Any],
        "config_loaded": bool,
    },
)

fields = FieldDict(
    outputs=dict[str, Any](),
    workspaces=dict[str, Any](),
    config_loaded=False,
)


def niri_action(*command: str) -> CompletedProcess[bytes]:
    return subprocess.run(["niri", "msg", "action", *command])


def niri_cmd(*command: str) -> CompletedProcess[str]:
    return subprocess.run(
        ["stdbuf", "-oL", "niri", "msg", "--json", *command],
        stdout=subprocess.PIPE,
        text=True,
    )

def cmd(*command: str) -> CompletedProcess[bytes]:
    return subprocess.run(command)


def handle_overview(_event: dict[str, Any]) -> None:
    return
    # _ = subprocess.run(
    #     ["qs ipc call dock toggle"],
    #     shell=True,
    # )

def float_window(event: dict[str, Any]) -> None:
    window_id = event["window"]["id"]
    _ = niri_action("move-window-to-floating", "--id", str(window_id))

def resize_window(event: dict[str, Any], x: int, y: int) -> None:
    window_id = str(event["window"]["id"])
    _ = niri_action("set-window-width", "--id", window_id, str(x))
    _ = niri_action("set-window-height", "--id", window_id, str(y))

def send_window_to_corner(event: dict[str, Any]) -> None:
    # Do some math on size and current output to move to corner
    window_size = event["window"]["layout"]["window_size"]
    window_id = event["window"]["id"]
    workspace_id = event["window"]["workspace_id"]
    output_id = fields["workspaces"][workspace_id]["output"]
    output_size: tuple[int, int] = (
        fields["outputs"][output_id]["logical"]["width"],
        fields["outputs"][output_id]["logical"]["height"],
    )

    gap = 20
    bar = 35
    pos = (
        output_size[0] - gap - window_size[0],
        output_size[1] - gap - bar - window_size[1],
    )

    _ = niri_action(
        "move-floating-window",
        "--id",
        str(window_id),
        "-x",
        str(pos[0]),
        "-y",
        str(pos[1]),
    )

    pass



def update_workspaces(event: dict[str, Any]) -> None:
    # Update the workspaces
    fields["workspaces"] = {ws["id"]: ws for ws in event["workspaces"]}
    # Update the outputs (because output changes don't send events)
    response = niri_cmd("outputs")
    response_text = response.stdout.strip()

    try:
        outputs: dict[str, Any] = json.loads(response_text)
        fields["outputs"] = outputs
    except json.JSONDecodeError:
        print("ERROR: failed to update outputs.")

class Rule():
    app_id: str | re.Pattern | None
    app_title: str | re.Pattern | None
    operations: list[tuple[Any, ...]]

    def __init__(
        self,
        *operations: Callable[[dict[str, Any]]] | tuple[Any, ...],
        app_id: str | re.Pattern | None = None,
        app_title: str | re.Pattern | None = None,
    ) -> None:
        self.app_id = app_id
        self.app_title = app_title
        self.operations = [op if isinstance(op, tuple) else (op,) for op in operations]

    def match(self, event: dict[str, Any]) -> bool:
        window_id = event["window"]["app_id"]
        window_title = event["window"]["title"]
        if isinstance(self.app_id, re.Pattern):
            if re.search(self.app_id, window_id):
                return True
        elif self.app_id == window_id:
            return True

        if isinstance(self.app_title, re.Pattern):
            if re.search(self.app_title, window_title):
                return True
        elif self.app_title == window_title:
            return True

        return False

    def apply(self, event: dict[str, Any]) -> None:
        if not self.match(event):
            return
        for opfunc, *args in self.operations:
            opfunc(event, *args)

RULES: list[Rule] = [
    Rule(send_window_to_corner, app_id="OneDriveGUI"),
    Rule(send_window_to_corner, app_id="Mullvad VPN"),
    Rule(send_window_to_corner, ("resize", 20, 20), app_id="org.gnome.gitlab.cheywood.Buffer"),
    Rule(send_window_to_corner, app_id="bitwarden"),
    Rule(send_window_to_corner, app_title="Noctalia Update Script"),
    Rule(float_window, (resize_window, 500, 800), app_title=re.compile(r"Extension:.*Bitwarden.*")),
]



def handle_event(event: dict[str, Any]) -> None:
    if "OverviewOpenedOrClosed" in event:
        handle_overview(event["OverviewOpenedOrClosed"])
    elif "WindowOpenedOrChanged" in event:
        for rule in RULES:
            rule.apply(event["WindowOpenedOrChanged"])
    elif "WorkspacesChanged" in event:
        update_workspaces(event["WorkspacesChanged"])


def niri_stream() -> None:
    """Keep a Niri event stream open, parsing and handling events."""
    event_stream = subprocess.Popen(
        ["stdbuf", "-oL", "niri", "msg", "--json", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
    )

    if event_stream.stdout is None:
        print("ERROR: Event stream stdout is None.")
        return

    for line in event_stream.stdout:
        line = line.strip()
        if not line:
            continue

        try:
            event: dict[str, Any] = json.loads(line)

            # Can't set dock to show or hide, only toggle, so have to ignore initial state
            # Wait until first config load to start handling events
            if "ConfigLoaded" in event:
                fields["config_loaded"] = True
            handle_event(event)
        except json.JSONDecodeError:
            print("ERROR: Event JSON parse failure.")
            continue
        except Exception:
            print("ERROR: Event handling failed.")
            print(traceback.format_exc())
            continue


def main() -> None:
    threads = list[threading.Thread]()
    threads.append(threading.Thread(target=niri_stream))

    for thread in threads:
        thread.start()

    try:
        for thread in threads:
            thread.join()
    except KeyboardInterrupt:
        sys.exit()


if __name__ == "__main__":
    main()
