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

    onExpandedChanged: {
        if (expanded) Network.startScan()
        else Network.stopScan()
    }

    visible: Network.wifiEnabled === true
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
                    name: Network.icon !== null && Network.icon !== undefined ? Network.icon : "wifi-high"
                    size: Spacing.iconSm
                    iconState: Network.connected === true ? "active" : "default"
                }

                Label {
                    Layout.fillWidth: true
                    text: Network.connected === true ? Network.ssid : "Not connected"
                    color: Network.connected === true ? Colors.textPrimary : Colors.textMuted
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
            id: networkList
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 2

            Repeater {
                model: Network.networks

                delegate: Rectangle {
                    id: networkItem

                    required property var modelData

                    readonly property bool isConnected: modelData !== null && modelData !== undefined && modelData.connected === true
                    readonly property string networkName: modelData !== null && modelData !== undefined ? (modelData.name || "") : ""
                    readonly property real networkStrength: modelData !== null && modelData !== undefined ? (modelData.signalStrength || 0) : 0

                    Layout.fillWidth: true
                    implicitHeight: networkRow.implicitHeight + Spacing.paddingSm * 2
                    radius: Spacing.radiusSm
                    visible: networkName !== ""

                    color: {
                        if (isConnected) return Colors.withAlpha(Colors.accent, networkMouse.containsMouse ? 0.2 : 0.12)
                        return networkMouse.containsMouse ? Colors.bgHover : "transparent"
                    }

                    Behavior on color {
                        ColorAnimation { duration: Motion.hoverDuration }
                    }

                    RowLayout {
                        id: networkRow
                        anchors.fill: parent
                        anchors.leftMargin: Spacing.paddingSm
                        anchors.rightMargin: Spacing.paddingSm
                        anchors.topMargin: Spacing.paddingSm
                        anchors.bottomMargin: Spacing.paddingSm
                        spacing: Spacing.spacingSm

                        DuotoneIcon {
                            name: {
                                if (networkItem.networkStrength < 0.30) return "wifi-low"
                                if (networkItem.networkStrength < 0.60) return "wifi-medium"
                                return "wifi-high"
                            }
                            size: Spacing.iconSm
                            iconState: networkItem.isConnected ? "active" : "default"
                        }

                        Body {
                            Layout.fillWidth: true
                            text: networkItem.networkName
                            color: networkItem.isConnected ? Colors.accent : Colors.textPrimary
                        }

                        Label {
                            visible: networkItem.isConnected
                            text: "Connected"
                            color: Colors.accent
                        }
                    }

                    MouseArea {
                        id: networkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if (networkItem.isConnected) {
                                Network.disconnectFromNetwork()
                            } else {
                                Network.connectToNetwork(networkItem.modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
