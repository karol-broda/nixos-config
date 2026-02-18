pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var pinnedApps: [
        { name: "Firefox", appId: "firefox", exec: "firefox" },
        { name: "WezTerm", appId: "org.wezfurlong.wezterm", exec: "wezterm" },
        { name: "Spotify", appId: "spotify", exec: "spotify" },
        { name: "Vesktop", appId: "vesktop", exec: "vesktop" }
    ]

    readonly property bool showFrame: true
    readonly property int maxWorkspaces: 10
}
