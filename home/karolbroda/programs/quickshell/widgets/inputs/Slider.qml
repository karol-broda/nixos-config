import QtQuick
import qs.theme

Item {
    id: root

    property real value: 0.5
    property real minValue: 0
    property real maxValue: 1

    signal moved(real value)

    property real _dragValue: 0
    readonly property real _displayValue: mouseArea.pressed ? _dragValue : value
    readonly property real _ratio: maxValue > minValue
        ? Math.max(0, Math.min(1, (_displayValue - minValue) / (maxValue - minValue))) : 0

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
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: track.width * root._ratio
            radius: track.radius
            color: Colors.accent

            Behavior on width {
                enabled: !mouseArea.pressed
                NumberAnimation { duration: Motion.durationFast }
            }
        }
    }

    Rectangle {
        width: 16
        height: 16
        radius: width / 2
        color: Colors.textPrimary
        x: track.x + (track.width - width) * root._ratio
        anchors.verticalCenter: parent.verticalCenter
        scale: mouseArea.pressed ? 1.2 : (mouseArea.containsMouse ? 1.1 : 1)

        Behavior on scale {
            NumberAnimation { duration: Motion.pressDuration }
        }

        Behavior on x {
            enabled: !mouseArea.pressed
            NumberAnimation { duration: Motion.durationFast }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: mouse => root._updateDrag(mouse.x)
        onPositionChanged: mouse => {
            if (pressed) root._updateDrag(mouse.x)
        }
        onWheel: wheel => {
            const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x
            if (delta === 0) return
            const step = (root.maxValue - root.minValue) * 0.05
            const next = root._clamp(root._displayValue + (delta > 0 ? step : -step))
            if (pressed) root._dragValue = next
            root.moved(next)
            wheel.accepted = true
        }
    }

    function _clamp(next: real): real {
        return Math.max(root.minValue, Math.min(root.maxValue, next))
    }

    function _updateDrag(mouseX: real): void {
        const ratio = root.width > 0 ? Math.max(0, Math.min(1, mouseX / root.width)) : 0
        root._dragValue = root.minValue + ratio * (root.maxValue - root.minValue)
        root.moved(root._dragValue)
    }
}
