#!/usr/bin/env python3
# Adapted from gvolpe's nfsm daemon: https://github.com/gvolpe/nfsm
# pyright: reportAny=false
# pyright: reportExplicitAny=false

import json
import subprocess
from subprocess import CompletedProcess
import sys
import threading
import traceback
from typing import Any, TypedDict

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


def handle_overview(_event: dict[str, Any]) -> None:
    # return
    _ = subprocess.run(
        ["qs -c $HOME/.config/quickshell/noctalia-shell/ ipc call dock toggle"],
        shell=True,
    )


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


def handle_event(event: dict[str, Any]) -> None:
    if "OverviewOpenedOrClosed" in event:
        handle_overview(event["OverviewOpenedOrClosed"])
    elif "WindowOpenedOrChanged" in event and event["WindowOpenedOrChanged"]["window"][
        "app_id"
    ] in ("OneDriveGUI", "Mullvad VPN"):
        send_window_to_corner(event["WindowOpenedOrChanged"])
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
