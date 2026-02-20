import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.services

Item {
    id: root

    property var menuHandle: null
    property var trayItemData: null
    property real flyoutRightEdge: 0

    signal closed()

    implicitWidth: menuColumn.implicitWidth + Spacing.paddingSm * 2
    implicitHeight: menuColumn.implicitHeight + Spacing.paddingSm * 2
    height: implicitHeight

    QsMenuOpener {
        id: menuOpener
    }

    Timer {
        id: _refreshTimer
        interval: 150
        onTriggered: {
            if (root.menuHandle === null || root.menuHandle === undefined) return
            var h = root.menuHandle
            menuOpener.menu = null
            menuOpener.menu = h
        }
    }

    onMenuHandleChanged: {
        Tray.closeAllSubMenus()

        if (root.menuHandle === null || root.menuHandle === undefined) {
            menuOpener.menu = null
            return
        }

        menuOpener.menu = root.menuHandle
    }

    ColumnLayout {
        id: menuColumn
        anchors.fill: parent
        anchors.margins: Spacing.paddingSm
        spacing: 0

        Text {
            id: tooltipLabel
            Layout.fillWidth: true
            Layout.bottomMargin: Spacing.spacingXs
            text: {
                if (root.trayItemData === null || root.trayItemData === undefined) {
                    return ""
                }
                return Tray.getTooltip(root.trayItemData)
            }
            font.family: Typography.labelFamily
            font.pixelSize: Typography.sizeMicro
            font.letterSpacing: Typography.microLabelSpacing
            color: Colors.textDim
            elide: Text.ElideRight
            visible: text !== ""
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.bottomMargin: Spacing.spacingXs
            height: 1
            color: Colors.divider
            visible: tooltipLabel.visible
        }

        Repeater {
            id: menuRepeater
            model: menuOpener.children

            delegate: MenuEntry {
                onTriggered: _refreshTimer.restart()
                onSubMenuRequested: function(globalY) {
                    Tray.openSubMenu(modelData, root.flyoutRightEdge, globalY, 0)
                }
                onNonSubHovered: Tray.closeAllSubMenus()
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: Spacing.spacingXs
            visible: menuRepeater.count === 0
            text: "loading…"
            font.family: Typography.labelFamily
            font.pixelSize: Typography.sizeMicro
            font.italic: true
            color: Colors.textDim
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
