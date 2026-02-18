import QtQuick
import qs.theme

Item {
    id: root

    property real value: 0.5
    property real minValue: 0.0
    property real maxValue: 1.0
    property bool enabled: true

    signal userValueChanged(real newValue)

    implicitWidth: 200
    implicitHeight: 24

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 6
        radius: height / 2
        color: Colors.bgElevated

        Rectangle {
            id: fill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * ((root.value - root.minValue) / (root.maxValue - root.minValue))
            radius: parent.radius
            color: Colors.accent

            Behavior on width {
                enabled: mouseArea.pressed === false
                NumberAnimation { duration: Motion.durationFast }
            }
        }
    }

    Rectangle {
        id: handle
        width: 16
        height: 16
        radius: width / 2
        color: Colors.textPrimary
        x: track.x + (track.width - width) * ((root.value - root.minValue) / (root.maxValue - root.minValue))
        anchors.verticalCenter: parent.verticalCenter

        scale: mouseArea.pressed ? 1.2 : (mouseArea.containsMouse ? 1.1 : 1.0)

        Behavior on scale {
            NumberAnimation { duration: Motion.pressDuration }
        }

        Behavior on x {
            enabled: mouseArea.pressed === false
            NumberAnimation { duration: Motion.durationFast }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: function(mouse) {
            if (root.enabled) {
                updateValue(mouse.x)
            }
        }

        onPositionChanged: function(mouse) {
            if (root.enabled && pressed) {
                updateValue(mouse.x)
            }
        }

        function updateValue(mouseX) {
            const ratio = Math.max(0, Math.min(1, mouseX / root.width))
            const newValue = root.minValue + ratio * (root.maxValue - root.minValue)
            if (newValue !== root.value) {
                root.value = newValue
                root.userValueChanged(newValue)
            }
        }
    }
}
