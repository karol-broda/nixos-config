pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string current: ""
    property var list: []

    readonly property string homeDir: Quickshell.env("HOME") || "/home/karolbroda"
    readonly property string wallpaperDir: homeDir + "/Pictures/Wallpapers"

    function setWallpaper(path: string): void {
        current = path
        wallpaperTimer.wallpaperPath = path
        wallpaperTimer.restart()
    }

    Component.onCompleted: {
        current = ""
        getWallsProc.running = true
    }

    Process {
        id: getWallsProc

        running: false
        command: [
            "find", "-L",
            root.wallpaperDir,
            "-type", "d", "-path", "*/.*", "-prune",
            "-o", "-not", "-name", ".*", "-type", "f", "-print"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text === null || text === undefined || text.trim() === "") {
                    root.list = []
                    return
                }

                const validExtensions = [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"]
                const wallpapers = text.trim()
                    .split("\n")
                    .filter(w => {
                        if (w === null || w === undefined || w === "") return false
                        const lower = w.toLowerCase()
                        return validExtensions.some(ext => lower.endsWith(ext))
                    })
                    .sort()

                root.list = wallpapers

                if (wallpapers.length > 0 && (root.current === null || root.current === "")) {
                    root.setWallpaper(wallpapers[0])
                }
            }
        }
    }

    Timer {
        id: wallpaperTimer

        property string wallpaperPath

        interval: 100
        onTriggered: {
            if (wallpaperPath !== null && wallpaperPath !== undefined && wallpaperPath !== "") {
                Quickshell.execDetached(["hyprctl", "hyprpaper", "wallpaper", "," + wallpaperPath])
            }
        }
    }
}
