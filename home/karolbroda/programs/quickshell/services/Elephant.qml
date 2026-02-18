pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<var> results: []
    property string currentQuery: ""
    property string activeProvider: ""
    property string pendingProvider: "desktopapplications"
    property string pendingSearchText: ""

    readonly property int queryLimit: 12

    readonly property var hiddenApps: [
        "cursor"
    ]

    readonly property var providerPrefixes: ({
        ">files ": "files",
        ">file ": "files",
        ">f ": "files",
        ">clip ": "clipboard",
        ">clipboard ": "clipboard",
        ">c ": "clipboard",
        ">win ": "windows",
        ">window ": "windows",
        ">w ": "windows",
        ">run ": "runner",
        ">r ": "runner",
        ">web ": "websearch",
        ">search ": "websearch",
        ">s ": "websearch",
        ">wall": "wallpaper",
        ">wallpaper": "wallpaper"
    })

    readonly property var providerMeta: ({
        "desktopapplications": {
            icon: "app-window",
            label: "Apps"
        },
        "files": {
            icon: "folder",
            label: "Files"
        },
        "clipboard": {
            icon: "clipboard",
            label: "Clipboard"
        },
        "windows": {
            icon: "browsers",
            label: "Windows"
        },
        "runner": {
            icon: "terminal",
            label: "Run"
        },
        "calc": {
            icon: "calculator",
            label: "Calc"
        },
        "websearch": {
            icon: "globe",
            label: "Web"
        },
        "wallpaper": {
            icon: "image",
            label: "Wallpaper"
        }
    })

    readonly property bool isWallpaperMode: root.activeProvider === "wallpaper"

    signal resultsReady

    function query(searchText: string): void {
        if (searchText === null || searchText === undefined) {
            searchText = ""
        }

        let provider = ""
        let actualQuery = searchText

        for (const prefix in root.providerPrefixes) {
            if (searchText.startsWith(prefix)) {
                provider = root.providerPrefixes[prefix]
                actualQuery = searchText.slice(prefix.length)
                break
            }
        }

        root.activeProvider = provider

        if (provider === "wallpaper") {
            root.searchWallpapers(actualQuery)
            return
        }

        root.currentQuery = actualQuery
        root.pendingProvider = provider !== "" ? provider : "desktopapplications"
        root.pendingSearchText = actualQuery

        queryTimer.restart()
    }

    function activate(item: var): void {
        if (item === null || item === undefined) {
            return
        }

        const identifier = item.identifier
        const provider = item.provider

        if (identifier === null || identifier === undefined || identifier === "") {
            return
        }

        const activationStr = provider + ";" + identifier + ";start;;"
        activateProc.command = ["elephant", "activate", activationStr]
        activateProc.running = true
    }

    function parseResults(stdout: string): list<var> {
        const items = []
        if (stdout === null || stdout === undefined || stdout.trim() === "") {
            return items
        }

        const lines = stdout.trim().split("\n")

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i]
            if (line.trim() === "") {
                continue
            }

            try {
                const resp = JSON.parse(line)
                const item = resp.item
                if (item !== null && item !== undefined) {
                    const id = (item.identifier || "").toLowerCase()
                    if (root.isHiddenApp(id)) {
                        continue
                    }

                    const prov = item.provider || ""
                    const meta = root.providerMeta[prov]
                    const provIcon = meta !== null && meta !== undefined ? meta.icon : "question"
                    const provLabel = meta !== null && meta !== undefined ? meta.label : prov

                    items.push({
                        label: item.text || "",
                        sublabel: item.subtext || "",
                        icon: item.icon || "",
                        identifier: item.identifier || "",
                        provider: prov,
                        providerIcon: provIcon,
                        providerLabel: provLabel,
                        score: item.score || 0,
                        actions: item.actions || []
                    })
                }
            } catch (e) {
                // ignore parse errors
            }
        }

        items.sort((a, b) => b.score - a.score)
        return items
    }

    Timer {
        id: queryTimer
        interval: 30
        repeat: false

        onTriggered: {
            const queryStr = root.pendingProvider + ";" + root.pendingSearchText + ";" + root.queryLimit + ";false"
            queryProc.command = ["elephant", "query", "--json", queryStr]
            queryProc.running = true
        }
    }

    Process {
        id: queryProc

        environment: ({
            PATH: "/run/current-system/sw/bin:/etc/profiles/per-user/karolbroda/bin"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                root.results = root.parseResults(text)
                root.resultsReady()
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                root.results = []
                root.resultsReady()
            }
        }
    }

    Process {
        id: activateProc

        environment: ({
            PATH: "/run/current-system/sw/bin:/etc/profiles/per-user/karolbroda/bin"
        })
    }

    function isHiddenApp(identifier: string): bool {
        for (let i = 0; i < root.hiddenApps.length; i++) {
            if (identifier.indexOf(root.hiddenApps[i]) !== -1) {
                return true
            }
        }
        return false
    }

    function searchWallpapers(searchText: string): void {
        const wallpapers = Wallpapers.list
        if (wallpapers === null || wallpapers === undefined || wallpapers.length === 0) {
            root.results = []
            root.resultsReady()
            return
        }

        const query = searchText.toLowerCase()
        const items = []

        for (let i = 0; i < wallpapers.length && items.length < root.queryLimit; i++) {
            const path = wallpapers[i]
            if (path === null || path === undefined) continue

            const filename = path.split("/").pop() || path
            const name = filename.replace(/\.[^.]+$/, "").replace(/[-_]/g, " ")

            if (query === "" || filename.toLowerCase().includes(query) || name.toLowerCase().includes(query)) {
                items.push({
                    label: name,
                    sublabel: path,
                    icon: "",
                    identifier: path,
                    provider: "wallpaper",
                    providerIcon: "image",
                    providerLabel: "Wallpaper",
                    score: query === "" ? i : (name.toLowerCase().startsWith(query) ? 100 : 50),
                    actions: [],
                    isWallpaper: true,
                    wallpaperPath: path
                })
            }
        }

        items.sort((a, b) => b.score - a.score)
        root.results = items
        root.resultsReady()
    }

    function activateWallpaper(path: string): void {
        if (path === null || path === undefined || path === "") return
        Wallpapers.setWallpaper(path)
    }

    Component.onCompleted: {
        query("")
    }
}
