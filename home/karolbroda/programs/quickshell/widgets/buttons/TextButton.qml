import QtQuick
import qs.theme
import qs.widgets.text
import qs.widgets.icons

Item {
    id: root

    property string text: ""
    property string icon: ""
    property bool enabled: true
    property bool primary: false
    property alias hovered: mouseArea.containsMouse
    property alias pressed: mouseArea.pressed

    signal clicked()

    implicitWidth: content.implicitWidth + Spacing.paddingMd * 2
    implicitHeight: Spacing.iconLg + Spacing.paddingSm * 2
    opacity: enabled ? 1.0 : 0.5

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Spacing.radiusSm
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

    transform: Scale {
        origin.x: root.width / 2
        origin.y: root.height / 2
        xScale: root.pressed ? 0.96 : 1.0
        yScale: root.pressed ? 0.96 : 1.0

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
