import QtQuick
import qs.theme

Behavior on y {
    NumberAnimation {
        duration: Motion.panelCloseDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.curveExit
    }
}
