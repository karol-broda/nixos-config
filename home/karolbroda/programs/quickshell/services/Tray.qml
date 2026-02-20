pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.theme

Singleton {
    id: root

    readonly property var items: SystemTray.items

    readonly property bool hasItems: itemCount > 0
    property int itemCount: 0

    property var activeMenuHandle: null
    property var activeMenuItem: null
    property var subMenuStack: []
    property var closingSubMenus: []

    function _stageForClose(items) {
        if (items.length === 0) return
        root.closingSubMenus = items
        _closingCleanup.restart()
    }

    Timer {
        id: _closingCleanup
        interval: Motion.panelCloseDuration
        onTriggered: root.closingSubMenus = []
    }

    function openMenu(item) {
        if (item === null || item === undefined) return

        if (item.hasMenu !== true) {
            activate(item)
            return
        }

        if (root.activeMenuItem === item) {
            closeMenu()
            return
        }

        _stageForClose(root.subMenuStack)
        root.activeMenuItem = item
        root.activeMenuHandle = item.menu
        root.subMenuStack = []
    }

    function closeMenu() {
        _stageForClose(root.subMenuStack)
        root.activeMenuHandle = null
        root.activeMenuItem = null
        root.subMenuStack = []
    }

    function openSubMenu(entry, xPos, yPos, level) {
        if (entry === null || entry === undefined) return
        var removed = root.subMenuStack.slice(level)
        _stageForClose(removed)
        var stack = root.subMenuStack.slice(0, level)
        stack.push({ entry: entry, x: xPos, y: yPos })
        root.subMenuStack = stack
        entry.updateLayout()
    }

    function closeSubMenusFrom(level) {
        if (root.subMenuStack.length <= level) return
        var removed = root.subMenuStack.slice(level)
        _stageForClose(removed)
        root.subMenuStack = root.subMenuStack.slice(0, level)
    }

    function closeAllSubMenus() {
        _stageForClose(root.subMenuStack)
        root.subMenuStack = []
    }

    function getIconSource(item) {
        if (item === null || item === undefined) {
            return "";
        }

        if (item.icon !== null && item.icon !== undefined && item.icon !== "") {
            return item.icon;
        }

        return "";
    }

    function isDirectIconPath(iconStr) {
        if (iconStr === null || iconStr === undefined || iconStr === "") {
            return false;
        }
        return iconStr.startsWith("/")
            || iconStr.startsWith("file://")
            || iconStr.startsWith("image://");
    }

    function getTooltip(item) {
        if (item === null || item === undefined) {
            return "";
        }

        if (item.tooltipTitle !== null && item.tooltipTitle !== undefined && item.tooltipTitle !== "") {
            return item.tooltipTitle;
        }

        if (item.title !== null && item.title !== undefined && item.title !== "") {
            return item.title;
        }

        if (item.id !== null && item.id !== undefined && item.id !== "") {
            return item.id;
        }

        return "unknown";
    }

    function activate(item) {
        if (item === null || item === undefined) {
            return;
        }
        item.activate();
    }

    function secondaryActivate(item) {
        if (item === null || item === undefined) {
            return;
        }
        item.secondaryActivate();
    }

    function scroll(item, delta, horizontal) {
        if (item === null || item === undefined) {
            return;
        }
        item.scroll(delta, horizontal);
    }
}
