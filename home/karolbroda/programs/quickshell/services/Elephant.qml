pragma Singleton

import Quickshell
import QtQuick
import qs.core

Singleton {
    id: root

    property var response: ({ query: "", items: [] })

    readonly property int queryLimit: 12

    readonly property var hiddenApps: ["cursor"]

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
        ">wallpaper ": "wallpaper",
        ">wallpaper": "wallpaper",
        ">wall ": "wallpaper",
        ">wall": "wallpaper"
    })

    readonly property var _prefixesByLength: Object.keys(providerPrefixes).sort((a, b) => b.length - a.length)

    readonly property var providerMeta: ({
        desktopapplications: { icon: "app-window", label: "Apps" },
        files: { icon: "folder", label: "Files" },
        clipboard: { icon: "clipboard", label: "Clipboard" },
        windows: { icon: "browsers", label: "Windows" },
        runner: { icon: "terminal", label: "Run" },
        calc: { icon: "calculator", label: "Calc" },
        websearch: { icon: "globe", label: "Web" },
        wallpaper: { icon: "image", label: "Wallpaper" }
    })

    property string _pendingText: ""

    function query(text: string): void {
        root._pendingText = text
        debounce.restart()
    }

    function parseQuery(text: string): var {
        const prefix = root._prefixesByLength.find(p => text.startsWith(p))
        if (prefix === undefined) return { provider: "desktopapplications", query: text }
        return { provider: root.providerPrefixes[prefix], query: text.slice(prefix.length) }
    }

    function activate(item: var): void {
        if (!item?.identifier) return
        const action = item.actions?.[0] ?? ""
        Env.launch(["elephant", "activate", item.provider + ";" + item.identifier + ";" + action + ";;"])
    }

    function _isHidden(provider: string, identifier: string): bool {
        if (provider !== "desktopapplications") return false
        const id = identifier.toLowerCase()
        return root.hiddenApps.some(app => id.includes(app))
    }

    function _parseResults(output: string): var {
        const items = []
        for (const line of output.split("\n")) {
            if (line.trim() === "") continue

            let item
            try {
                item = JSON.parse(line).item
            } catch (e) {
                continue
            }
            if (!item) continue

            const provider = item.provider ?? ""
            const identifier = item.identifier ?? ""
            if (root._isHidden(provider, identifier)) continue

            const meta = root.providerMeta[provider]
            items.push({
                label: item.text ?? "",
                sublabel: item.subtext ?? "",
                icon: item.icon ?? "",
                identifier: identifier,
                provider: provider,
                providerIcon: meta?.icon ?? "question",
                providerLabel: meta?.label ?? provider,
                score: item.score ?? 0,
                actions: item.actions ?? [],
                preview: item.preview ?? "",
                previewType: item.preview_type ?? ""
            })
        }
        return items.sort((a, b) => b.score - a.score)
    }

    Timer {
        id: debounce
        interval: 30
        onTriggered: {
            const parsed = root.parseQuery(root._pendingText)
            const queryStr = parsed.provider + ";" + parsed.query + ";" + root.queryLimit + ";false"
            job.run(["elephant", "query", "--json", queryStr], root._pendingText)
        }
    }

    Job {
        id: job

        environment: Env.withProfilePath
        timeout: 5000
        onFinished: (tag, output, exitCode) => {
            root.response = { query: tag, items: exitCode === 0 ? root._parseResults(output) : [] }
        }
    }

    Component.onCompleted: query("")
}
