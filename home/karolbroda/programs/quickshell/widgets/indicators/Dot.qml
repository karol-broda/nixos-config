import QtQuick
import qs.theme

Item {
    id: root

    property bool isActive: false
    property bool isOccupied: false

    implicitWidth: 16
    implicitHeight: 16

    Rectangle {
        id: glow
        anchors.centerIn: parent
        width: 20
        height: 20
        radius: width / 2
        color: Colors.withAlpha(Colors.accent, 0.3)
        opacity: root.isActive ? 1 : 0
        scale: root.isActive ? 1 : 0.5

        Behavior on opacity {
            NumberAnimation { duration: Motion.glowDuration }
        }
        Behavior on scale {
            NumberAnimation { duration: Motion.glowDuration }
        }
    }

    Rectangle {
        id: dot
        anchors.centerIn: parent
        width: root.isActive ? 10 : 6
        height: width
        radius: width / 2

        color: {
            if (root.isActive) return Colors.accent
            if (root.isOccupied) return Colors.textMuted
            return "transparent"
        }

        border.width: root.isOccupied === false && root.isActive === false ? 1 : 0
        border.color: Colors.textDim

        Behavior on width {
            NumberAnimation {
                duration: Motion.dotDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Motion.curveGlide
            }
        }

        Behavior on color {
            ColorAnimation { duration: Motion.dotDuration }
        }
    }
}
