import QtQuick
import qs.theme
import qs.widgets.text
import qs.widgets.icons

ButtonBase {
    id: root

    property string icon: ""
    property string label: ""
    property bool isOn: false

    signal toggled()

    implicitWidth: 72
    implicitHeight: 64

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radiusInner
        color: {
            if (root.isOn) {
                return Colors.withAlpha(Colors.accent, root.hovered ? 0.25 : 0.2)
            }
            return root.hovered ? Colors.bgHover : Colors.bgElevated
        }
        border.width: root.isOn ? 1 : 0
        border.color: Colors.withAlpha(Colors.accent, 0.4)

        Behavior on color {
            ColorAnimation { duration: Motion.hoverDuration }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Spacing.spacingXs

        DuotoneIcon {
            anchors.horizontalCenter: parent.horizontalCenter
            name: root.icon
            size: Spacing.iconMd
            iconState: root.isOn ? "active" : (root.hovered ? "hover" : "default")
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            font.pixelSize: Typography.sizeMicro
            font.letterSpacing: Typography.microLabelSpacing
            color: root.isOn ? Colors.accent : Colors.textMuted
        }
    }

    onClicked: root.toggled()
}
