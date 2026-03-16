import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.theme
import qs.core
import qs.services
import qs.features.panels.home
import qs.features.panels.dashboard
import qs.features.panels.launcher
import qs.features.panels.notifications

Item {
    id: root

    required property bool screenActive
    required property bool isActiveScreen
    required property var panelWindow

    HyprlandFocusGrab {
        active: root.screenActive
        windows: [root.panelWindow]
        onCleared: {
            Dispatcher.dispatch(Actions.closePanel())
        }
    }

    MouseArea {
        anchors.fill: parent
        visible: root.screenActive
        onClicked: {
            Dispatcher.dispatch(Actions.closePanel())
        }
    }

    PanelOutline {
        id: panelOutline

        property var _subMenuRects: {
            var result = []
            var count = traySubMenuRepeater.count
            for (var i = 0; i < count; i++) {
                var item = traySubMenuRepeater.itemAt(i)
                if (item !== null && item !== undefined && item.width > 0 && item.height > 0) {
                    result.push(item.panelRect)
                }
            }
            var closingCount = closingSubMenuRepeater.count
            for (var j = 0; j < closingCount; j++) {
                var ci = closingSubMenuRepeater.itemAt(j)
                if (ci !== null && ci !== undefined && ci.width > 0 && ci.height > 0) {
                    result.push(ci.panelRect)
                }
            }
            return result
        }

        panels: [
            homePanel.panelRect,
            trayFlyout.panelRect,
            dashboardPanel.panelRect,
            launcherPanel.panelRect,
            notifPanel.panelRect
        ].concat(_subMenuRects)
        frameTop: Spacing.panelTopInset
        frameLeft: Spacing.panelSideInset
        frameRight: root.width - Spacing.panelSideInset
        frameBottom: root.height - Spacing.panelSideInset
        gapThreshold: Spacing.panelGap + Spacing.panelRadius
    }

    HomePanel {
        id: homePanel
        screenActive: root.screenActive
        anchors.left: parent.left
        anchors.leftMargin: Spacing.panelSideInset
        anchors.top: parent.top
        anchors.topMargin: Spacing.panelTopInset
    }

    TrayFlyout {
        id: trayFlyout
        panelOpen: homePanel.isOpen
        x: homePanel.x + homePanel.width
        anchors.top: parent.top
        anchors.topMargin: Spacing.panelTopInset
    }

    Repeater {
        id: traySubMenuRepeater
        model: root.isActiveScreen ? Tray.subMenuStack : []

        delegate: TraySubMenu {
            required property var modelData
            required property int index

            x: modelData.x
            y: modelData.y
            menuEntry: modelData.entry
            level: index
        }
    }

    Repeater {
        id: closingSubMenuRepeater
        model: root.isActiveScreen ? Tray.closingSubMenus : []

        delegate: TraySubMenu {
            required property var modelData
            required property int index

            x: modelData.x
            y: modelData.y
            menuEntry: modelData.entry
            level: index
            closing: true
        }
    }

    DashboardPanel {
        id: dashboardPanel
        screenActive: root.screenActive
        anchors.right: parent.right
        anchors.rightMargin: Spacing.panelSideInset
        anchors.top: parent.top
        anchors.topMargin: Spacing.panelTopInset
    }

    LauncherPanel {
        id: launcherPanel
        screenActive: root.screenActive
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Spacing.panelTopInset
    }

    NotifPanel {
        id: notifPanel
        screenActive: root.screenActive
        anchors.right: parent.right
        anchors.rightMargin: Spacing.panelSideInset
        anchors.top: parent.top
        anchors.topMargin: Spacing.panelTopInset
    }

    Item {
        focus: root.screenActive

        Keys.onEscapePressed: {
            Dispatcher.handleEscape()
        }
    }
}
