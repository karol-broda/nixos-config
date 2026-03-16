pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property string defaultIcon: "application-x-executable"

    // resolve an icon source from a wayland/hyprland app id.
    // tries desktop entry lookup with multiple normalization strategies,
    // then falls back to direct icon theme lookup.
    function forApp(appId, fallback) {
        if (!_hasValue(appId)) {
            return _resolveFallback(fallback)
        }

        if (_isDirectSource(appId)) {
            return appId
        }

        // try finding icon via desktop entry (multiple strategies)
        var iconFromEntry = _lookupDesktopIcon(appId)
        if (_hasValue(iconFromEntry)) {
            if (_isDirectSource(iconFromEntry)) {
                return iconFromEntry
            }

            var resolved = Quickshell.iconPath(iconFromEntry, true)
            if (_hasValue(resolved)) {
                return resolved
            }
        }

        // try resolving the app id itself, lowercased variant, and reverse-dns last segment
        var candidates = [appId]

        var lower = appId.toLowerCase()
        if (lower !== appId) {
            candidates.push(lower)
        }

        var dotIdx = appId.lastIndexOf(".")
        if (dotIdx > 0 && dotIdx < appId.length - 1) {
            candidates.push(appId.substring(dotIdx + 1).toLowerCase())
        }

        for (var i = 0; i < candidates.length; i++) {
            if (Quickshell.hasThemeIcon(candidates[i])) {
                return Quickshell.iconPath(candidates[i])
            }
        }

        // for hyphenated ids (google-chrome-stable), try progressively shorter prefixes
        var dashIdx = appId.lastIndexOf("-")
        while (dashIdx > 0) {
            var prefix = appId.substring(0, dashIdx)
            if (Quickshell.hasThemeIcon(prefix)) {
                return Quickshell.iconPath(prefix)
            }
            dashIdx = prefix.lastIndexOf("-")
        }

        return _resolveFallback(fallback)
    }

    // resolve an icon from a freedesktop icon name (e.g. "firefox", "audio-volume-high")
    function forName(iconName, fallback) {
        if (!_hasValue(iconName)) {
            return _resolveFallback(fallback)
        }

        if (_isDirectSource(iconName)) {
            return iconName
        }

        var resolved = Quickshell.iconPath(iconName, true)
        if (_hasValue(resolved)) {
            return resolved
        }

        var lower = iconName.toLowerCase()
        if (lower !== iconName) {
            resolved = Quickshell.iconPath(lower, true)
            if (_hasValue(resolved)) {
                return resolved
            }
        }

        return _resolveFallback(fallback)
    }

    function getDesktopEntry(appId) {
        if (!_hasValue(appId)) {
            return null
        }

        return _tryLookup(appId)
    }

    // get just the icon name string without resolving to a file path
    function getIconName(appId) {
        if (!_hasValue(appId)) {
            return root.defaultIcon
        }

        var iconName = _lookupDesktopIcon(appId)
        if (_hasValue(iconName)) {
            return iconName
        }

        return appId
    }

    // last-resort pixmap fallback for icons not found via the theme engine.
    // with system icon theme detection most icons resolve through hasThemeIcon,
    // but some nixos store-split icons still need direct path scanning.
    readonly property var _pixmapDirs: [
        "/run/current-system/sw/share/pixmaps/",
        "/run/current-system/sw/share/icons/hicolor/scalable/apps/",
        "/run/current-system/sw/share/icons/hicolor/256x256/apps/",
        "/run/current-system/sw/share/icons/hicolor/128x128/apps/",
        "/usr/share/pixmaps/"
    ]

    readonly property var _pixmapExts: [".svg", ".png", ".xpm"]

    function fallbackSources(name) {
        if (!_hasValue(name)) {
            return []
        }

        var sources = []
        var names = [name]

        var lower = name.toLowerCase()
        if (lower !== name) {
            names.push(lower)
        }

        for (var n = 0; n < names.length; n++) {
            for (var d = 0; d < _pixmapDirs.length; d++) {
                for (var e = 0; e < _pixmapExts.length; e++) {
                    sources.push("file://" + _pixmapDirs[d] + names[n] + _pixmapExts[e])
                }
            }
        }

        return sources
    }

    // --- internal helpers ---

    function _hasValue(val) {
        return val !== null && val !== undefined && val !== ""
    }

    function _isDirectSource(val) {
        return val.startsWith("/")
            || val.startsWith("file://")
            || val.startsWith("image://")
    }

    function _resolveFallback(fallback) {
        if (_hasValue(fallback)) {
            if (_isDirectSource(fallback)) {
                return fallback
            }
            return Quickshell.iconPath(fallback, root.defaultIcon)
        }
        return Quickshell.iconPath(root.defaultIcon)
    }

    function _tryLookup(appId) {
        var entry = DesktopEntries.heuristicLookup(appId)
        if (entry !== null && entry !== undefined) {
            return entry
        }
        return null
    }

    function _extractIcon(entry) {
        if (entry === null || entry === undefined) {
            return ""
        }
        var icon = entry.icon
        if (_hasValue(icon)) {
            return icon
        }
        return ""
    }

    // multi-strategy desktop entry icon lookup:
    // exact match → stripped .desktop suffix → lowercased → reverse-dns last segment
    function _lookupDesktopIcon(appId) {
        var entry = _tryLookup(appId)
        var icon = _extractIcon(entry)
        if (_hasValue(icon)) {
            return icon
        }

        if (appId.endsWith(".desktop")) {
            var stripped = appId.substring(0, appId.length - 8)
            entry = _tryLookup(stripped)
            icon = _extractIcon(entry)
            if (_hasValue(icon)) {
                return icon
            }
        }

        var lower = appId.toLowerCase()
        if (lower !== appId) {
            entry = _tryLookup(lower)
            icon = _extractIcon(entry)
            if (_hasValue(icon)) {
                return icon
            }
        }

        var dotIdx = appId.lastIndexOf(".")
        if (dotIdx > 0 && dotIdx < appId.length - 1) {
            var tail = appId.substring(dotIdx + 1)
            entry = _tryLookup(tail)
            icon = _extractIcon(entry)
            if (_hasValue(icon)) {
                return icon
            }

            var lowerTail = tail.toLowerCase()
            if (lowerTail !== tail) {
                entry = _tryLookup(lowerTail)
                icon = _extractIcon(entry)
                if (_hasValue(icon)) {
                    return icon
                }
            }
        }

        return ""
    }
}
