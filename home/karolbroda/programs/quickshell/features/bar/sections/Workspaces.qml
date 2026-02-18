import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.theme
import qs.core
import qs.services
import qs.widgets.indicators
import qs.config

RowLayout {
    id: root

    property var screen: null

    readonly property HyprlandMonitor monitor: {
        if (screen === null || screen === undefined) return null
        return Hyprland.monitorFor(screen)
    }

    readonly property int activeWsIdForMonitor: {
        if (monitor === null || monitor === undefined) return -1
        const aw = monitor.activeWorkspace
        if (aw === null || aw === undefined) return -1
        return aw.id
    }

    spacing: Spacing.spacingSm

    Repeater {
        model: Config.maxWorkspaces

        Dot {
            required property int index

            readonly property int wsId: index + 1

            isActive: root.activeWsIdForMonitor === wsId

            isOccupied: {
                const ws = Hyprland.workspaces
                if (ws === null || ws === undefined) {
                    return false
                }
                for (let i = 0; i < ws.length; i++) {
                    if (ws[i] !== null && ws[i] !== undefined && ws[i].id === wsId) {
                        return true
                    }
                }
                return false
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Dispatcher.dispatch(Actions.switchWorkspace(wsId))
                }
            }
        }
    }
}
