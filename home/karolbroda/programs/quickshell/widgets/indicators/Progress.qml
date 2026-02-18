import QtQuick
import qs.theme

Item {
    id: root

    property real value: 0.5
    property real minValue: 0.0
    property real maxValue: 1.0
    property int barHeight: 4

    implicitWidth: 100
    implicitHeight: barHeight

    Rectangle {
        id: track
        anchors.fill: parent
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
                NumberAnimation { duration: Motion.durationMedium }
            }
        }
    }
}
