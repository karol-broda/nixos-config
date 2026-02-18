import QtQuick
import qs.theme
import qs.services
import qs.widgets.indicators

Item {
    id: root

    implicitWidth: Players.isPlaying === true ? 140 : 0
    implicitHeight: Spacing.barHeight - 8

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Motion.durationSlow
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Motion.curveGlide
        }
    }

    Item {
        id: content
        width: 140
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        transformOrigin: Item.Center

        opacity: 0
        scale: 0.3

        states: [
            State {
                name: "playing"
                when: Players.isPlaying === true
                PropertyChanges {
                    target: content
                    opacity: 1
                    scale: 1
                }
            }
        ]

        transitions: [
            Transition {
                to: "playing"
                SequentialAnimation {
                    PauseAnimation { duration: 100 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: content
                            property: "opacity"
                            duration: Motion.durationSlow
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Motion.curveEnter
                        }
                        NumberAnimation {
                            target: content
                            property: "scale"
                            duration: 500
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Motion.curveSpring
                        }
                    }
                }
            },
            Transition {
                from: "playing"
                to: ""
                ParallelAnimation {
                    NumberAnimation {
                        target: content
                        property: "opacity"
                        duration: Motion.durationFast
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Motion.curveExit
                    }
                    NumberAnimation {
                        target: content
                        property: "scale"
                        duration: Motion.durationMedium
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Motion.curveExit
                    }
                }
            }
        ]

        CavaShader {
            anchors.fill: parent
        }
    }
}
