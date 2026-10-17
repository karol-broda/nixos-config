import QtQuick
import qs.theme
import qs.services
import qs.widgets.icons

Item {
    id: root

    readonly property string kind: OsdState.shownKind
    readonly property bool isBattery: kind === "battery"

    readonly property real level: {
        if (kind === "volume") return Audio.muted ? 0 : Audio.volume
        if (kind === "brightness") return Brightness.brightness
        return Battery.percentage / 100
    }

    implicitWidth: isBattery ? 180 : 220
    implicitHeight: isBattery ? 56 : 60

    Row {
        anchors.centerIn: parent
        spacing: Spacing.spacingMd

        DuotoneIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: {
                if (root.kind === "volume") return Audio.icon
                if (root.kind === "brightness") return Brightness.icon
                return Battery.icon
            }
            size: Spacing.iconLg
            iconState: {
                if (root.kind === "volume" && Audio.muted) return "disabled"
                if (root.isBattery && !Battery.pluggedIn) return "default"
                return "active"
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.isBattery ? 2 : 4

            Text {
                visible: root.isBattery
                font.family: Typography.osdStatusFamily
                font.pixelSize: Typography.osdStatusSize
                font.weight: Typography.osdStatusWeight
                font.letterSpacing: Typography.osdStatusSpacing
                color: Colors.textPrimary
                text: Battery.pluggedIn ? "Charging" : "Unplugged"
            }

            Rectangle {
                visible: !root.isBattery
                width: 140
                height: 8
                radius: height / 2
                color: Colors.bgElevated

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * Math.max(0, Math.min(1, root.level))
                    radius: parent.radius
                    color: Colors.accent

                    Behavior on width {
                        SmoothedAnimation { velocity: 600 }
                    }
                }
            }

            Text {
                width: root.isBattery ? implicitWidth : 140
                horizontalAlignment: root.isBattery ? Text.AlignLeft : Text.AlignHCenter
                font.family: Typography.monoTextFamily
                font.pixelSize: Typography.sizeCaption
                font.weight: Typography.monoTextWeight
                color: Colors.textMuted
                visible: !root.isBattery || Battery.available
                text: Math.round(root.level * 100) + "%"
            }
        }
    }
}
