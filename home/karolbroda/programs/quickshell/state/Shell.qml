pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.services

Singleton {
    id: root

    readonly property var panels: ["home", "dashboard", "launcher", "notifications"]

    property var current: null

    property bool locked: false

    readonly property string focusedScreen: {
        const names = Quickshell.screens.map(s => s.name)
        const focused = Hyprland.focusedMonitor?.name ?? ""
        if (names.includes(focused)) return focused
        return names[0] ?? ""
    }

    function isOpen(panel: string, screen: string): bool {
        return root.current !== null && root.current.panel === panel && root.current.screen === screen
    }

    function isActiveOn(screen: string): bool {
        return root.current !== null && root.current.screen === screen
    }

    function openPanel(panel: string): void {
        if (!root.panels.includes(panel)) {
            console.error("[Shell] unknown panel:", panel)
            return
        }
        if (root.focusedScreen === "") return
        if (root.isOpen(panel, root.focusedScreen)) return
        Tray.closeMenu()
        root.current = { panel: panel, screen: root.focusedScreen }
    }

    function closePanel(): void {
        if (root.current === null) return
        Tray.closeMenu()
        root.current = null
    }

    function togglePanel(panel: string): void {
        if (root.current !== null && root.current.panel === panel) root.closePanel()
        else root.openPanel(panel)
    }

    function handleEscape(): void {
        if (Tray.activeMenuItem !== null) Tray.closeMenu()
        else root.closePanel()
    }

    function lock(): void {
        root.closePanel()
        root.locked = true
    }

    function unlock(): void {
        root.locked = false
    }

    Connections {
        target: Quickshell

        function onScreensChanged(): void {
            if (root.current === null) return
            if (!Quickshell.screens.some(s => s.name === root.current.screen)) root.closePanel()
        }
    }
}
