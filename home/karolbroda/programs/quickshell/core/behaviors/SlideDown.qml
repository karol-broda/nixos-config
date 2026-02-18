import QtQuick
import qs.theme

Behavior on y {
    NumberAnimation {
        duration: Motion.panelOpenDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.curveSlide
    }
}
