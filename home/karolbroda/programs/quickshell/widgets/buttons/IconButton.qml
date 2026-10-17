import QtQuick
import qs.theme
import qs.widgets.icons

ButtonBase {
    id: root

    property string icon: ""
    property int size: Spacing.iconLg + Spacing.paddingSm * 2
    property int iconSize: Spacing.iconMd
    property bool active: false

    pressScale: 0.92

    implicitWidth: size
    implicitHeight: size

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radiusInner
        color: {
            if (root.pressed) return Colors.bgActive
            if (root.hovered) return Colors.bgHover
            if (root.active) return Colors.withAlpha(Colors.accent, 0.15)
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
            if (root.pressed || root.active) return "active"
            if (root.hovered) return "hover"
            return "default"
        }
    }
}
