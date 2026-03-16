import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.icons
import qs.widgets.text
import qs.widgets.buttons

Item {
    id: root

    property bool expanded: false

    signal headerClicked()

    visible: Bluetooth.enabled === true
    implicitHeight: column.implicitHeight
    clip: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.panelResizeDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Motion.curveSmooth
        }
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Spacing.spacingSm

        Rectangle {
            id: headerRow
            Layout.fillWidth: true
            implicitHeight: headerContent.implicitHeight + Spacing.paddingSm * 2
            radius: Spacing.radiusSm
            color: headerMouse.containsMouse ? Colors.bgHover : "transparent"

            Behavior on color {
                ColorAnimation { duration: Motion.hoverDuration }
            }

            RowLayout {
                id: headerContent
                anchors.fill: parent
                anchors.leftMargin: Spacing.paddingSm
                anchors.rightMargin: Spacing.paddingSm
                anchors.topMargin: Spacing.paddingSm
                anchors.bottomMargin: Spacing.paddingSm
                spacing: Spacing.spacingSm

                DuotoneIcon {
                    name: Bluetooth.icon !== null && Bluetooth.icon !== undefined ? Bluetooth.icon : "bluetooth"
                    size: Spacing.iconSm
                    iconState: Bluetooth.connectedDevices.length > 0 ? "active" : "default"
                }

                Label {
                    Layout.fillWidth: true
                    text: Bluetooth.statusText
                    color: Bluetooth.connectedDevices.length > 0 ? Colors.textPrimary : Colors.textMuted
                }

                DuotoneIcon {
                    name: root.expanded ? "caret-down" : "caret-right"
                    size: Spacing.iconSm
                    iconState: headerMouse.containsMouse ? "hover" : "default"
                }
            }

            MouseArea {
                id: headerMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    root.headerClicked()
                }
            }
        }

        ColumnLayout {
            id: deviceList
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 2

            Repeater {
                model: Bluetooth.deviceModel

                delegate: Rectangle {
                    id: deviceItem

                    required property var modelData

                    readonly property bool isConnected: modelData !== null && modelData !== undefined && modelData.connected === true
                    readonly property bool isPaired: modelData !== null && modelData !== undefined && modelData.paired === true
                    readonly property bool isTrusted: modelData !== null && modelData !== undefined && modelData.trusted === true
                    readonly property string deviceName: modelData !== null && modelData !== undefined ? (modelData.name || "") : ""
                    readonly property string deviceIconName: Bluetooth.deviceIcon(modelData !== null && modelData !== undefined ? modelData.icon : null)
                    readonly property bool hasBattery: modelData !== null && modelData !== undefined && modelData.batteryAvailable === true

                    Layout.fillWidth: true
                    readonly property bool isBonded: modelData !== null && modelData !== undefined && modelData.bonded === true
                    readonly property bool isKnown: isConnected || isTrusted || isPaired || isBonded

                    implicitHeight: isKnown && deviceName !== "" ? deviceRow.implicitHeight + Spacing.paddingSm * 2 : 0
                    radius: Spacing.radiusSm
                    visible: isKnown && deviceName !== ""
                    clip: true

                    color: {
                        if (isConnected) return Colors.withAlpha(Colors.accent, deviceMouse.containsMouse ? 0.2 : 0.12)
                        return deviceMouse.containsMouse ? Colors.bgHover : "transparent"
                    }

                    Behavior on color {
                        ColorAnimation { duration: Motion.hoverDuration }
                    }

                    RowLayout {
                        id: deviceRow
                        anchors.fill: parent
                        anchors.leftMargin: Spacing.paddingSm
                        anchors.rightMargin: Spacing.paddingSm
                        anchors.topMargin: Spacing.paddingSm
                        anchors.bottomMargin: Spacing.paddingSm
                        spacing: Spacing.spacingSm

                        DuotoneIcon {
                            name: deviceItem.deviceIconName
                            size: Spacing.iconSm
                            iconState: deviceItem.isConnected ? "active" : "default"
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Body {
                                Layout.fillWidth: true
                                text: deviceItem.deviceName
                                color: deviceItem.isConnected ? Colors.accent : Colors.textPrimary
                            }

                            Label {
                                Layout.fillWidth: true
                                visible: deviceItem.hasBattery
                                text: deviceItem.hasBattery ? Math.round(deviceItem.modelData.battery * 100) + "%" : ""
                                font.pixelSize: Typography.sizeCaption
                            }
                        }

                        Label {
                            visible: deviceItem.isConnected
                            text: "Connected"
                            color: Colors.accent
                        }

                        Label {
                            visible: !deviceItem.isConnected && deviceItem.isPaired
                            text: "Paired"
                            color: Colors.textDim
                        }

                        Label {
                            visible: !deviceItem.isConnected && !deviceItem.isPaired && (deviceItem.isTrusted || deviceItem.isBonded)
                            text: deviceItem.isTrusted ? "Trusted" : "Bonded"
                            color: Colors.textMuted
                        }
                    }

                    MouseArea {
                        id: deviceMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            Dispatcher.dispatch(Actions.toggleBluetoothDevice(deviceItem.modelData))
                        }
                    }
                }
            }
        }
    }
}
