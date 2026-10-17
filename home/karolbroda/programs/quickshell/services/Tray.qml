pragma Singleton

import Quickshell
import Quickshell.Services.SystemTray

Singleton {
    id: root

    readonly property var items: SystemTray.items
    property var activeMenuItem: null
    readonly property var activeMenu: activeMenuItem?.menu ?? null

    function openMenu(item: SystemTrayItem): void {
        if (!item) return
        if (!item.hasMenu) {
            root.activate(item)
            return
        }
        root.activeMenuItem = root.activeMenuItem === item ? null : item
    }

    function closeMenu(): void {
        root.activeMenuItem = null
    }

    function activate(item: SystemTrayItem): void {
        item?.activate()
    }

    function secondaryActivate(item: SystemTrayItem): void {
        item?.secondaryActivate()
    }

    function scroll(item: SystemTrayItem, delta: int, horizontal: bool): void {
        item?.scroll(delta, horizontal)
    }

    function iconSource(item: SystemTrayItem): string {
        return item?.icon ?? ""
    }

    function tooltip(item: SystemTrayItem): string {
        if (!item) return ""
        return item.tooltipTitle || item.title || item.id || "unknown"
    }
}
