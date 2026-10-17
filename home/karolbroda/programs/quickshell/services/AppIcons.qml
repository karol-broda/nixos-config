pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property string _defaultIcon: "application-x-executable"
    readonly property list<string> _pixmapDirs: [
        "/run/current-system/sw/share/pixmaps/",
        "/run/current-system/sw/share/icons/hicolor/scalable/apps/",
        "/run/current-system/sw/share/icons/hicolor/256x256/apps/",
        "/run/current-system/sw/share/icons/hicolor/128x128/apps/",
        "/usr/share/pixmaps/"
    ]
    readonly property list<string> _pixmapExts: [".svg", ".png", ".xpm"]

    function isDirectSource(s: string): bool {
        return s.startsWith("/") || s.startsWith("file://") || s.startsWith("image://")
    }

    function forApp(appId: string, fallback = ""): string {
        if (!appId) return root._resolveFallback(fallback)
        if (root.isDirectSource(appId)) return appId

        const entryIcon = root._lookupDesktopIcon(appId)
        if (entryIcon) {
            const resolved = root.isDirectSource(entryIcon) ? entryIcon : Quickshell.iconPath(entryIcon, true)
            if (resolved) return resolved
        }

        const candidates = [appId, appId.toLowerCase()]
        const tail = root._tail(appId)
        if (tail) candidates.push(tail.toLowerCase())
        let prefix = appId
        while (prefix.lastIndexOf("-") > 0) {
            prefix = prefix.slice(0, prefix.lastIndexOf("-"))
            candidates.push(prefix)
        }
        for (const candidate of candidates) {
            if (Quickshell.hasThemeIcon(candidate)) return Quickshell.iconPath(candidate)
        }
        return root._resolveFallback(fallback)
    }

    function forName(iconName: string, fallback = ""): string {
        if (!iconName) return root._resolveFallback(fallback)
        if (root.isDirectSource(iconName)) return iconName
        for (const candidate of [iconName, iconName.toLowerCase()]) {
            const resolved = Quickshell.iconPath(candidate, true)
            if (resolved) return resolved
        }
        return root._resolveFallback(fallback)
    }

    function getDesktopEntry(appId: string): DesktopEntry {
        return appId ? DesktopEntries.heuristicLookup(appId) ?? null : null
    }

    function getIconName(appId: string): string {
        return appId ? root._lookupDesktopIcon(appId) || appId : root._defaultIcon
    }

    function fallbackSources(name: string): list<string> {
        if (!name) return []
        const names = name === name.toLowerCase() ? [name] : [name, name.toLowerCase()]
        const sources = []
        for (const candidate of names) {
            for (const dir of root._pixmapDirs) {
                for (const ext of root._pixmapExts) sources.push("file://" + dir + candidate + ext)
            }
        }
        return sources
    }

    function _resolveFallback(fallback: string): string {
        if (!fallback) return Quickshell.iconPath(root._defaultIcon)
        return root.isDirectSource(fallback) ? fallback : Quickshell.iconPath(fallback, root._defaultIcon)
    }

    function _tail(appId: string): string {
        const dot = appId.lastIndexOf(".")
        return dot > 0 && dot < appId.length - 1 ? appId.slice(dot + 1) : ""
    }

    function _lookupDesktopIcon(appId: string): string {
        const candidates = [appId]
        if (appId.endsWith(".desktop")) candidates.push(appId.slice(0, -8))
        candidates.push(appId.toLowerCase())
        const tail = root._tail(appId)
        if (tail) candidates.push(tail, tail.toLowerCase())
        for (const candidate of candidates) {
            const icon = DesktopEntries.heuristicLookup(candidate)?.icon ?? ""
            if (icon) return icon
        }
        return ""
    }
}
