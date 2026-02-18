import QtQuick
import qs.theme

Behavior on opacity {
    NumberAnimation {
        duration: Motion.durationFast
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.curveExit
    }
}
