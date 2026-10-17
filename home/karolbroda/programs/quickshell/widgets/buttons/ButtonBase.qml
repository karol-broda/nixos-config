import QtQuick
import qs.theme

Item {
    id: root

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed
    property alias acceptedButtons: mouseArea.acceptedButtons
    property real pressScale: 0.94

    signal clicked(var mouse)

    opacity: enabled ? 1 : 0.5
    scale: pressed ? pressScale : 1

    Behavior on scale {
        NumberAnimation { duration: Motion.pressDuration }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: mouse => root.clicked(mouse)
    }
}
