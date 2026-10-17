import QtQuick
import qs.theme
import qs.widgets.text
import qs.widgets.icons

ButtonBase {
    id: root

    property string text: ""
    property string icon: ""
    property bool primary: false

    pressScale: 0.96

    implicitWidth: content.implicitWidth + Spacing.paddingMd * 2
    implicitHeight: Spacing.iconLg + Spacing.paddingSm * 2

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radiusInner
        color: {
            if (root.primary) {
                if (root.pressed) return Colors.accentAlt
                if (root.hovered) return Colors.accent
                return Colors.accent
            }
            if (root.pressed) return Colors.bgActive
            if (root.hovered) return Colors.bgHover
            return Colors.bgElevated
        }

        Behavior on color {
            ColorAnimation { duration: Motion.hoverDuration }
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Spacing.spacingSm

        DuotoneIcon {
            visible: root.icon !== ""
            anchors.verticalCenter: parent.verticalCenter
            name: root.icon
            size: Spacing.iconSm
            iconState: root.primary ? "active" : (root.hovered ? "hover" : "default")
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            color: root.primary ? Colors.crust : Colors.textPrimary
        }
    }
}
