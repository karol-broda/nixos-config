pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.services
import qs.widgets.indicators
import qs.config

RowLayout {
    id: root

    required property ShellScreen screen

    readonly property int activeId: Hypr.monitorFor(screen)?.activeWorkspace?.id ?? -1

    spacing: Spacing.spacingSm

    Repeater {
        model: Config.maxWorkspaces

        Dot {
            id: dot

            required property int index
            readonly property int wsId: index + 1

            isActive: root.activeId === wsId
            isOccupied: Hypr.isWorkspaceOccupied(wsId)

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hypr.focusWorkspace(dot.wsId)
            }
        }
    }
}
