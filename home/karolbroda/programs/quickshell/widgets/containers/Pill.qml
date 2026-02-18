import QtQuick
import qs.theme

Rectangle {
    id: root

    property bool hoverable: false
    property alias hovered: mouseArea.containsMouse

    default property alias content: contentItem.data

    color: hoverable && hovered ? Colors.barPillHover : Colors.barPill
    radius: Spacing.radiusFull

    Behavior on color {
        ColorAnimation { duration: Motion.hoverDuration }
    }

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: Spacing.paddingSm
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.hoverable
        acceptedButtons: Qt.NoButton
    }
}
