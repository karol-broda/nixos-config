import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.services

Item {
    id: root

    property var menuEntry: null
    property int level: 0

    readonly property var panelRect: ({
        x: root.x,
        y: root.y,
        w: root.width,
        h: root.height
    })

    width: 200
    height: subMenuColumn.implicitHeight + Spacing.paddingSm * 2

    QsMenuOpener {
        id: subMenuOpener
        menu: root.menuEntry
    }

    Timer {
        id: _refreshTimer
        interval: 150
        onTriggered: {
            if (root.menuEntry === null || root.menuEntry === undefined) return
            var e = root.menuEntry
            subMenuOpener.menu = null
            subMenuOpener.menu = e
        }
    }

    ColumnLayout {
        id: subMenuColumn
        anchors.fill: parent
        anchors.margins: Spacing.paddingSm
        spacing: 0

        Repeater {
            id: subMenuRepeater
            model: subMenuOpener.children

            delegate: Item {
                id: subEntry

                required property var modelData

                readonly property bool isSep: {
                    if (modelData === null || modelData === undefined) return false
                    return modelData.isSeparator === true
                }

                readonly property string label: {
                    if (modelData === null || modelData === undefined) return ""
                    if (modelData.text === null || modelData.text === undefined) return ""
                    return modelData.text
                }

                readonly property bool isEnabled: {
                    if (modelData === null || modelData === undefined) return false
                    return modelData.enabled !== false
                }

                readonly property bool isCheckable: {
                    if (modelData === null || modelData === undefined) return false
                    var bt = modelData.buttonType
                    return bt !== null && bt !== undefined && bt !== 0
                }

                readonly property bool isChecked: {
                    if (modelData === null || modelData === undefined) return false
                    return modelData.checkState === Qt.Checked
                }

                readonly property bool hasSub: {
                    if (modelData === null || modelData === undefined) return false
                    return modelData.hasChildren === true
                }

                Layout.fillWidth: true
                Layout.preferredHeight: isSep ? sepRect.height : rowRect.height
                visible: isSep || label !== ""

                Rectangle {
                    id: sepRect
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: Spacing.spacingSm + 1
                    color: "transparent"
                    visible: subEntry.isSep

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width
                        height: 1
                        color: Colors.divider
                    }
                }

                Rectangle {
                    id: rowRect
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 28
                    radius: Spacing.radiusXs
                    color: rowMouse.containsMouse && subEntry.isEnabled ? Colors.bgHover : "transparent"
                    visible: subEntry.isSep !== true
                    opacity: subEntry.isEnabled ? 1.0 : 0.4

                    Behavior on color {
                        ColorAnimation { duration: Motion.hoverDuration }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Spacing.paddingSm
                        anchors.rightMargin: Spacing.paddingSm
                        spacing: Spacing.spacingSm

                        Rectangle {
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
                            radius: subEntry.isCheckable ? 2 : 7
                            color: "transparent"
                            border.width: subEntry.isCheckable ? 1 : 0
                            border.color: subEntry.isChecked ? Colors.accent : Colors.overlay0
                            visible: subEntry.isCheckable

                            Rectangle {
                                anchors.centerIn: parent
                                width: 8
                                height: 8
                                radius: parent.radius > 2 ? 4 : 1
                                color: Colors.accent
                                visible: subEntry.isChecked
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: subEntry.label
                            font.family: Typography.bodyTextFamily
                            font.pixelSize: Typography.sizeLabel
                            font.weight: Typography.weightRegular
                            color: subEntry.isEnabled ? Colors.textPrimary : Colors.textDim
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            visible: subEntry.hasSub
                            text: "\u203A"
                            font.pixelSize: Typography.sizeBody
                            color: Colors.textDim
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: subEntry.isEnabled
                        cursorShape: subEntry.isEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                        onContainsMouseChanged: {
                            if (containsMouse !== true) return
                            if (subEntry.isEnabled !== true) return

                            if (subEntry.hasSub) {
                                var pos = rowRect.mapToItem(null, 0, 0)
                                Tray.openSubMenu(subEntry.modelData, root.x + root.width, pos.y, root.level + 1)
                            } else {
                                Tray.closeSubMenusFrom(root.level + 1)
                            }
                        }

                        onClicked: {
                            if (subEntry.isEnabled !== true) return
                            if (subEntry.modelData === null || subEntry.modelData === undefined) return

                            if (subEntry.hasSub) {
                                var pos = rowRect.mapToItem(null, 0, 0)
                                Tray.openSubMenu(subEntry.modelData, root.x + root.width, pos.y, root.level + 1)
                            } else {
                                subEntry.modelData.triggered()
                                _refreshTimer.restart()
                            }
                        }
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: Spacing.spacingXs
            visible: subMenuRepeater.count === 0
            text: "loading…"
            font.family: Typography.labelFamily
            font.pixelSize: Typography.sizeMicro
            font.italic: true
            color: Colors.textDim
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
