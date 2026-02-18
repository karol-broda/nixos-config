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

            delegate: Item {
                id: menuEntry

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
                Layout.preferredHeight: isSep ? separatorRow.height : entryRow.height
                visible: isSep || label !== ""

                Rectangle {
                    id: separatorRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: Spacing.spacingSm + 1
                    color: "transparent"
                    visible: menuEntry.isSep

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width
                        height: 1
                        color: Colors.divider
                    }
                }

                Rectangle {
                    id: entryRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 28
                    radius: Spacing.radiusXs
                    color: entryMouse.containsMouse && menuEntry.isEnabled ? Colors.bgHover : "transparent"
                    visible: menuEntry.isSep !== true
                    opacity: menuEntry.isEnabled ? 1.0 : 0.4

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
                            radius: menuEntry.isCheckable ? 2 : 7
                            color: "transparent"
                            border.width: menuEntry.isCheckable ? 1 : 0
                            border.color: menuEntry.isChecked ? Colors.accent : Colors.overlay0
                            visible: menuEntry.isCheckable

                            Rectangle {
                                anchors.centerIn: parent
                                width: 8
                                height: 8
                                radius: parent.radius > 2 ? 4 : 1
                                color: Colors.accent
                                visible: menuEntry.isChecked
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: menuEntry.label
                            font.family: Typography.bodyTextFamily
                            font.pixelSize: Typography.sizeLabel
                            font.weight: Typography.weightRegular
                            color: menuEntry.isEnabled ? Colors.textPrimary : Colors.textDim
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            visible: menuEntry.hasSub
                            text: "\u203A"
                            font.pixelSize: Typography.sizeBody
                            color: Colors.textDim
                        }
                    }

                    MouseArea {
                        id: entryMouse
                        anchors.fill: parent
                        hoverEnabled: menuEntry.isEnabled
                        cursorShape: menuEntry.isEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                        onContainsMouseChanged: {
                            if (containsMouse !== true) return
                            if (menuEntry.isEnabled !== true) return

                            if (menuEntry.hasSub) {
                                var pos = entryRow.mapToItem(null, 0, 0)
                                Tray.openSubMenu(menuEntry.modelData, root.flyoutRightEdge, pos.y, 0)
                            } else {
                                Tray.closeAllSubMenus()
                            }
                        }

                        onClicked: {
                            if (menuEntry.isEnabled !== true) return
                            if (menuEntry.modelData === null || menuEntry.modelData === undefined) return

                            if (menuEntry.hasSub) {
                                var pos = entryRow.mapToItem(null, 0, 0)
                                Tray.openSubMenu(menuEntry.modelData, root.flyoutRightEdge, pos.y, 0)
                            } else {
                                menuEntry.modelData.triggered()
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
