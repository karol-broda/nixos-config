import QtQuick
import qs.theme

Behavior on y {
    NumberAnimation {
        duration: Motion.panelDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.curveSlide
    }
}
