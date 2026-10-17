pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.icons
import qs.widgets.text

ColumnLayout {
    id: root

    spacing: Spacing.spacingSm

    Label {
        text: "System Tray"
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 6
        rowSpacing: Spacing.spacingSm
        columnSpacing: Spacing.spacingSm

        Repeater {
            id: trayRepeater
            model: Tray.items

            Item {
                id: trayItem

                required property var modelData

                readonly property string iconSource: Tray.iconSource(modelData)
                readonly property bool isDirect: AppIcons.isDirectSource(iconSource)

                Layout.preferredWidth: 32
                Layout.preferredHeight: 32

                Rectangle {
                    anchors.fill: parent
                    radius: Spacing.radiusInner
                    color: {
                        if (Tray.activeMenuItem === trayItem.modelData) return Colors.bgActive
                        if (trayMouse.containsMouse) return Colors.bgHover
                        return "transparent"
                    }

                    Behavior on color {
                        ColorAnimation { duration: Motion.hoverDuration }
                    }
                }

                AppIcon {
                    anchors.centerIn: parent
                    size: Spacing.iconMd
                    source: trayItem.isDirect ? trayItem.iconSource : ""
                    iconName: trayItem.isDirect ? "" : trayItem.iconSource
                }

                MouseArea {
                    id: trayMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: Tray.openMenu(trayItem.modelData)
                }
            }
        }
    }

    Label {
        Layout.fillWidth: true
        visible: trayRepeater.count === 0
        text: "No tray items"
        color: Colors.textDim
        horizontalAlignment: Text.AlignHCenter
    }
}
