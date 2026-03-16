import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

import qs.core
import qs.services
import qs.features.lockscreen
import qs.features.screenshot

ShellRoot {
    id: root

    Process {
        id: devModeCheck
        command: ["sh", "-c", "test -z \"$INVOCATION_ID\" && echo dev"]

        stdout: SplitParser {
            onRead: function(data) {
                console.log("devModeCheck:", data.trim())
                if (data.trim() === "dev") {
                    Quickshell.watchFiles = true
                }
            }
        }
    }

    Component.onCompleted: {
        // nix symlinks to the store cause spurious inotify events,
        // so disable file watching by default and only enable it
        // when running outside of a systemd service (i.e. development)
        Quickshell.watchFiles = false
        devModeCheck.running = true
        console.log("Shell loaded")
    }

    GlobalShortcut {
        name: "launcher"
        description: "Open application launcher"

        onPressed: {
            Dispatcher.dispatch(Actions.togglePanel("launcher"))
        }
    }

    GlobalShortcut {
        name: "lock"
        description: "Lock the session"

        onPressed: {
            lock.locked = true
        }
    }

    Connections {
        target: Dispatcher

        function onLockRequested() {
            lock.locked = true
        }
    }

    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false
            lockContext.clearPassword()
        }
    }

    WlSessionLock {
        id: lock

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    ScreenshotOverlay {}

    Variants {
        model: Quickshell.screens

        ScreenLayout {
            property var modelData
            screen: modelData
        }
    }
}
