import QtQuick
import qs.theme

Item {
    id: root

    property bool open: false

    property string edge: "top"

    property real contentWidth: 0
    property real contentHeight: 0

    property bool fadeContent: true

    property bool interactive: true

    default property alias content: contentArea.data

    property real progress: 0
    Component.onCompleted: progress = Qt.binding(() => open ? 1 : 0)

    readonly property bool shown: progress > Motion.progressEpsilon || open

    readonly property bool isSurface: true

    readonly property bool _growsX: edge === "left" || edge === "right" || edge.includes("-")
    readonly property bool _growsY: edge === "top" || edge === "bottom" || edge.includes("-")
    readonly property bool _fromTop: edge.startsWith("top")
    readonly property bool _fromBottom: edge.startsWith("bottom")
    readonly property bool _fromLeft: edge === "left" || edge.endsWith("-left")
    readonly property bool _fromRight: edge === "right" || edge.endsWith("-right")

    property real _w: contentWidth
    property real _h: contentHeight

    readonly property real _p: Math.max(0, progress)

    Behavior on progress {
        SpringAnimation {
            spring: Motion.surfaceSpring
            damping: Motion.surfaceDamping
            mass: Motion.surfaceMass
            epsilon: Motion.progressEpsilon
        }
    }

    Behavior on _w {
        enabled: root.shown
        SpringAnimation {
            spring: Motion.resizeSpring
            damping: Motion.resizeDamping
            epsilon: Motion.pixelEpsilon
        }
    }

    Behavior on _h {
        enabled: root.shown
        SpringAnimation {
            spring: Motion.resizeSpring
            damping: Motion.resizeDamping
            epsilon: Motion.pixelEpsilon
        }
    }

    implicitWidth: _growsX ? _w * _p : _w
    implicitHeight: _growsY ? _h * _p : _h
    width: implicitWidth
    height: implicitHeight

    visible: shown && width > 0.5 && height > 0.5
    clip: true

    MouseArea {
        anchors.fill: parent
        enabled: root.interactive
        acceptedButtons: Qt.AllButtons
    }

    Item {
        id: contentArea

        width: root.contentWidth
        height: root.contentHeight

        x: root._fromRight ? root.width - width : (root._fromLeft ? 0 : (root.width - width) / 2)
        y: root._fromBottom ? root.height - height : (root._fromTop ? 0 : (root.height - height) / 2)

        opacity: root.fadeContent ? Math.min(1, Math.max(0, (root.progress - 0.35) / 0.65)) : 1
        transform: Translate {
            readonly property real offset: root.fadeContent ? (1 - Math.min(1, root._p)) * 8 : 0
            x: root._fromLeft ? -offset : (root._fromRight ? offset : 0)
            y: root._fromTop ? -offset : (root._fromBottom ? offset : 0)
        }
    }
}
