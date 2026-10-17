pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property int durationInstant: 100
    readonly property int durationFast: 150
    readonly property int durationNormal: 200
    readonly property int durationMedium: 250
    readonly property int durationSlow: 400
    readonly property int durationVerySlow: 600

    readonly property int panelOpenDuration: 350
    readonly property int panelCloseDuration: 260
    readonly property int panelResizeDuration: 250
    readonly property int hoverDuration: 150
    readonly property int pressDuration: 100
    readonly property int glowDuration: 300
    readonly property int dotDuration: 400

    readonly property var curveEnter: [0.0, 0.0, 0.2, 1.0, 1, 1]

    readonly property var curveExit: [0.15, 0.4, 0.15, 1.0, 1, 1]

    readonly property var curveGlide: [0.23, 1.0, 0.32, 1.0, 1, 1]

    readonly property var curveSlide: [0.25, 0.1, 0.1, 1.0, 1, 1]

    readonly property var curveSpring: [0.34, 1.56, 0.64, 1.0, 1, 1]

    readonly property var curveSmooth: [0.4, 0.0, 0.2, 1.0, 1, 1]

    readonly property int staggerDelay: 50
    readonly property int contentDelay: 70


    readonly property real surfaceSpring: 4.2
    readonly property real surfaceDamping: 0.34
    readonly property real surfaceMass: 1.0
    readonly property real progressEpsilon: 0.002

    readonly property real resizeSpring: 4.6
    readonly property real resizeDamping: 0.38
    readonly property real pixelEpsilon: 0.25
}
