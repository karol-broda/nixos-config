import QtQuick
import qs.theme

Item {
    id: root

    property bool open: false
    property int targetWidth: 300
    property int targetHeight: 400

    // which corner/edge the panel slides from
    // "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
    property string slideFrom: "top-left"

    // exposed geometry for PanelOutline to read
    readonly property var panelRect: ({
        x: root.x,
        y: root.y,
        w: root.width,
        h: root.height
    })

    default property alias content: contentArea.data

    readonly property bool _isCorner: slideFrom.indexOf("-") !== -1
    readonly property bool _isHorizontal: slideFrom === "left" || slideFrom === "right"
    readonly property bool _isVertical: slideFrom === "top" || slideFrom === "bottom"

    readonly property bool _animateWidth: _isCorner || _isHorizontal
    readonly property bool _animateHeight: _isCorner || _isVertical

    clip: true

    implicitWidth: (_animateWidth && !open) ? 0 : targetWidth
    implicitHeight: (_animateHeight && !open) ? 0 : targetHeight

    Behavior on implicitWidth {
        enabled: root._animateWidth

        NumberAnimation {
            duration: root.open ? Motion.panelOpenDuration : Motion.panelCloseDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root.open ? Motion.curveSlide : Motion.curveExit
        }
    }

    Behavior on implicitHeight {
        enabled: root._animateHeight

        NumberAnimation {
            duration: root.open ? Motion.panelOpenDuration : Motion.panelCloseDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root.open ? Motion.curveSlide : Motion.curveExit
        }
    }

    // content container anchored to the slide-from corner/edge
    Item {
        id: contentArea

        width: root.targetWidth
        height: root.targetHeight

        anchors.left: {
            if (root.slideFrom === "left"
                || root.slideFrom === "top-left"
                || root.slideFrom === "bottom-left"
                || root.slideFrom === "top"
                || root.slideFrom === "bottom") {
                return parent.left
            }
            return undefined
        }
        anchors.right: {
            if (root.slideFrom === "right"
                || root.slideFrom === "top-right"
                || root.slideFrom === "bottom-right") {
                return parent.right
            }
            return undefined
        }
        anchors.top: {
            if (root.slideFrom === "top"
                || root.slideFrom === "top-left"
                || root.slideFrom === "top-right"
                || root.slideFrom === "left"
                || root.slideFrom === "right") {
                return parent.top
            }
            return undefined
        }
        anchors.bottom: {
            if (root.slideFrom === "bottom"
                || root.slideFrom === "bottom-left"
                || root.slideFrom === "bottom-right") {
                return parent.bottom
            }
            return undefined
        }

        anchors.horizontalCenter: root._isVertical ? parent.horizontalCenter : undefined
        anchors.verticalCenter: root._isHorizontal ? parent.verticalCenter : undefined

        opacity: root.open ? 1 : 0

        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: root.open ? Motion.contentDelay : 0 }
                NumberAnimation {
                    duration: Motion.durationNormal
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.curveEnter
                }
            }
        }
    }
}
