import QtQuick
import qs.theme

Behavior on scale {
    NumberAnimation {
        duration: Motion.durationFast
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.curveSpring
    }
}
