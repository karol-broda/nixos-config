import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import qs.state
import qs.features.lockscreen
import qs.features.screenshot

ShellRoot {
    id: root

    Component.onCompleted: Quickshell.watchFiles = !Quickshell.env("INVOCATION_ID")

    GlobalShortcut {
        name: "launcher"
        description: "Open application launcher"
        onPressed: Shell.togglePanel("launcher")
    }

    GlobalShortcut {
        name: "dashboard"
        description: "Toggle the dashboard"
        onPressed: Shell.togglePanel("dashboard")
    }

    GlobalShortcut {
        name: "lock"
        description: "Lock the session"
        onPressed: Shell.lock()
    }

    IpcHandler {
        target: "shell"

        function togglePanel(name: string): void {
            Shell.togglePanel(name)
        }

        function closePanel(): void {
            Shell.closePanel()
        }

        function lock(): void {
            Shell.lock()
        }
    }

    LockScreen {
        locked: Shell.locked
        onUnlocked: Shell.unlock()
    }

    ScreenshotOverlay {}

    Variants {
        model: Quickshell.screens

        ScreenLayout {
            required property ShellScreen modelData
            screen: modelData
        }
    }
}
