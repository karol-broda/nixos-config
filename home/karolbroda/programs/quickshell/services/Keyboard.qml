pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string layout: layoutFull.slice(0, 2).toLowerCase()
    property string layoutFull: "?"

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name === "activelayout") {
                root.layoutFull = event.parse(2)[1];
            }
        }
    }

    Process {
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: root.layoutFull = JSON.parse(text).keyboards.find(k => k.main).active_keymap
        }
    }
}
