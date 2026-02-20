import QtQuick
import qs.theme
import qs.core
import qs.services
import qs.widgets.icons

Item {
    id: root

    property var screen: null

    property bool initialized: false
    property string osdType: ""
    property string displayType: ""

    readonly property bool pluggedIn: Battery.available === true && (Battery.charging === true || Battery.fullyCharged === true)

    onOsdTypeChanged: {
        if (osdType !== "") {
            displayType = osdType;
        }
    }

    anchors.fill: parent

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: {
            root.osdType = ""
        }
    }

    Timer {
        id: batteryHideTimer
        interval: 2500
        onTriggered: {
            root.osdType = ""
        }
    }

    Connections {
        target: Audio

        function onVolumeChanged() {
            if (!root.initialized) return
            root.osdType = "volume"
            hideTimer.restart()
        }

        function onMutedChanged() {
            if (!root.initialized) return
            root.osdType = "volume"
            hideTimer.restart()
        }
    }

    Connections {
        target: Brightness

        function onBrightnessChanged() {
            if (!root.initialized) return
            root.osdType = "brightness"
            hideTimer.restart()
        }
    }

    onPluggedInChanged: {
        if (!root.initialized) return
        root.osdType = "battery"
        batteryHideTimer.restart()
    }

    // defer initialization so initial property values don't trigger the osd
    Timer {
        interval: 500
        running: true
        onTriggered: root.initialized = true
    }

    PanelOutline {
        panels: [
            volumeDrawer.panelRect,
            batteryDrawer.panelRect
        ]
        frameBottom: root.height - Spacing.panelSideInset
    }

    EdgeDrawer {
        id: volumeDrawer

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Spacing.panelSideInset

        edge: "bottom"
        open: root.osdType === "volume" || root.osdType === "brightness"
        contentWidth: 220
        contentHeight: 60

        Row {
            anchors.centerIn: parent
            spacing: Spacing.spacingMd

            DuotoneIcon {
                anchors.verticalCenter: parent.verticalCenter
                name: {
                    if (root.displayType === "volume") {
                        return Audio.icon !== null && Audio.icon !== undefined ? Audio.icon : "speaker-high"
                    }
                    if (root.displayType === "brightness") {
                        return Brightness.icon !== null && Brightness.icon !== undefined ? Brightness.icon : "sun"
                    }
                    return "speaker-high"
                }
                size: Spacing.iconLg
                iconState: (root.displayType === "volume" && Audio.muted === true) ? "disabled" : "active"
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Rectangle {
                    width: 140
                    height: 8
                    radius: height / 2
                    color: Colors.bgElevated

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: {
                            var val = 0
                            if (root.displayType === "volume") {
                                val = Audio.muted === true ? 0 : (Audio.volume !== null && Audio.volume !== undefined ? Audio.volume : 0)
                            } else if (root.displayType === "brightness") {
                                val = Brightness.brightness !== null && Brightness.brightness !== undefined ? Brightness.brightness : 0
                            }
                            return parent.width * Math.max(0, Math.min(1, val))
                        }
                        radius: parent.radius
                        color: Colors.accent

                        Behavior on width {
                            NumberAnimation { duration: 50 }
                        }
                    }
                }

                Text {
                    width: 140
                    horizontalAlignment: Text.AlignHCenter
                    font.family: Typography.monoTextFamily
                    font.pixelSize: Typography.sizeCaption
                    font.weight: Typography.monoTextWeight
                    color: Colors.textMuted
                    text: {
                        var val = 0
                        if (root.displayType === "volume") {
                            val = Audio.muted === true ? 0 : (Audio.volume !== null && Audio.volume !== undefined ? Audio.volume : 0)
                        } else if (root.displayType === "brightness") {
                            val = Brightness.brightness !== null && Brightness.brightness !== undefined ? Brightness.brightness : 0
                        }
                        return Math.round(val * 100) + "%"
                    }
                }
            }
        }
    }

    EdgeDrawer {
        id: batteryDrawer

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Spacing.panelSideInset

        edge: "bottom"
        open: root.osdType === "battery"
        contentWidth: 180
        contentHeight: 56

        Row {
            anchors.centerIn: parent
            spacing: Spacing.spacingMd

            DuotoneIcon {
                anchors.verticalCenter: parent.verticalCenter
                name: Battery.icon !== null && Battery.icon !== undefined ? Battery.icon : "battery-full"
                size: Spacing.iconLg
                iconState: root.pluggedIn ? "active" : "default"
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    font.family: Typography.osdStatusFamily
                    font.pixelSize: Typography.osdStatusSize
                    font.weight: Typography.osdStatusWeight
                    font.letterSpacing: Typography.osdStatusSpacing
                    color: Colors.textPrimary
                    text: root.pluggedIn ? "Charging" : "Unplugged"
                }

                Text {
                    font.family: Typography.monoTextFamily
                    font.pixelSize: Typography.sizeCaption
                    font.weight: Typography.monoTextWeight
                    color: Colors.textMuted
                    text: Battery.percentageInt + "%"
                    visible: Battery.available === true
                }
            }
        }
    }
}
