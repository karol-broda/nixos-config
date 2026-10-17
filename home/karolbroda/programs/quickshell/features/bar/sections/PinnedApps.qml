pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.config
import qs.services
import qs.widgets.icons

RowLayout {
    id: root

    spacing: Spacing.spacingXs

    Repeater {
        model: Config.pinnedApps

        Item {
            id: app

            required property var modelData

            Layout.preferredWidth: Spacing.barHeight - 4
            Layout.preferredHeight: Spacing.barHeight - 4

            Rectangle {
                anchors.fill: parent
                radius: Spacing.radiusInner
                color: mouseArea.containsMouse ? Colors.bgHover : "transparent"

                Behavior on color {
                    ColorAnimation { duration: Motion.hoverDuration }
                }
            }

            AppIcon {
                anchors.centerIn: parent
                appId: app.modelData.appId
                size: Spacing.iconMd
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Env.launch([app.modelData.exec])
            }
        }
    }
}
