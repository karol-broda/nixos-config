import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.icons
import qs.widgets.text

Item {
    id: root

    implicitHeight: trayContent.implicitHeight

    ColumnLayout {
        id: trayContent
        anchors.left: parent.left
        anchors.right: parent.right
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

                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32

                    Rectangle {
                        anchors.fill: parent
                        radius: Spacing.radiusSm
                        color: {
                            if (Tray.activeMenuItem !== null && Tray.activeMenuItem === trayItem.modelData) {
                                return Colors.bgActive
                            }
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

                        property string _trayIcon: Tray.getIconSource(trayItem.modelData)
                        property bool _isDirect: Tray.isDirectIconPath(_trayIcon)

                        source: _isDirect ? _trayIcon : ""
                        iconName: _isDirect !== true ? _trayIcon : ""
                    }

                    MouseArea {
                        id: trayMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: function(mouse) {
                            if (trayItem.modelData === null || trayItem.modelData === undefined) {
                                return
                            }
                            Tray.openMenu(trayItem.modelData)
                        }
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
}
