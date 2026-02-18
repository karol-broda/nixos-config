import QtQuick
import qs.theme

Behavior on opacity {
    NumberAnimation {
        duration: Motion.durationMedium
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.curveEnter
    }
}
