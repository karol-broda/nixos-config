import QtQuick
import qs.theme
import qs.widgets.icons

Item {
    id: root

    property string icon: ""
    property int size: Spacing.iconLg + Spacing.paddingSm * 2
    property int iconSize: Spacing.iconMd
    property bool enabled: true
    property alias hovered: mouseArea.containsMouse
    property alias pressed: mouseArea.pressed

    signal clicked()

    implicitWidth: size
    implicitHeight: size
    opacity: enabled ? 1.0 : 0.5

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Spacing.radiusSm
        color: {
            if (root.pressed) return Colors.bgActive
            if (root.hovered) return Colors.bgHover
            return "transparent"
        }

        Behavior on color {
            ColorAnimation { duration: Motion.hoverDuration }
        }
    }

    DuotoneIcon {
        anchors.centerIn: parent
        name: root.icon
        size: root.iconSize
        iconState: {
            if (root.enabled === false) return "disabled"
            if (root.pressed) return "active"
            if (root.hovered) return "hover"
            return "default"
        }
    }

    transform: Scale {
        origin.x: root.width / 2
        origin.y: root.height / 2
        xScale: root.pressed ? 0.92 : 1.0
        yScale: root.pressed ? 0.92 : 1.0

        Behavior on xScale {
            NumberAnimation { duration: Motion.pressDuration }
        }
        Behavior on yScale {
            NumberAnimation { duration: Motion.pressDuration }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (root.enabled) {
                root.clicked()
            }
        }
    }
}
