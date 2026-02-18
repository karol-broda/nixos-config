import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.theme
import qs.config
import qs.widgets.icons

RowLayout {
    id: root

    spacing: Spacing.spacingXs

    Repeater {
        model: Config.pinnedApps

        Item {
            id: appItem

            required property var modelData
            required property int index

            Layout.preferredWidth: Spacing.barHeight - 4
            Layout.preferredHeight: Spacing.barHeight - 4

            Rectangle {
                anchors.fill: parent
                radius: Spacing.radiusSm
                color: mouseArea.containsMouse ? Colors.bgHover : "transparent"

                Behavior on color {
                    ColorAnimation { duration: Motion.hoverDuration }
                }
            }

            AppIcon {
                anchors.centerIn: parent
                appId: appItem.modelData.appId
                size: Spacing.iconMd
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    launchProc.command = [appItem.modelData.exec]
                    launchProc.running = true
                }
            }

            Process {
                id: launchProc
            }
        }
    }
}
