import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.theme
import qs.services

Item {
    id: root
    implicitWidth: 900
    implicitHeight: 600

    required property var context

    readonly property string currentTime: Time.format("HH:mm")
    readonly property string currentDate: Time.format("dddd, MMMM d")

    property real shaderTime: 0

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            root.shaderTime += 0.016
        }
    }

    ShaderEffect {
        id: noiseShader
        anchors.fill: parent

        property real time: root.shaderTime
        property color color1: Colors.base
        property color color2: Colors.mauve
        property color color3: Colors.flamingo
        property color color4: Colors.rosewater
        property real seed: Math.random() * 100

        fragmentShader: "noise.frag.qsb"
    }

    Item {
        anchors.centerIn: parent
        width: 450
        height: 380

        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            text: root.currentTime
            font.family: Typography.displayFamily
            font.pixelSize: Typography.lockClockSize
            font.weight: Typography.lockClockWeight
            font.letterSpacing: Typography.lockClockSpacing
            color: Colors.text

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Colors.withAlpha(Colors.mauve, 0.25)
                shadowBlur: 0.25
                shadowVerticalOffset: 2
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: clockText.bottom
            anchors.topMargin: 6
            spacing: 8
            height: 4

            Rectangle { width: 20; height: 1; color: Colors.withAlpha(Colors.lavender, 0.4); anchors.verticalCenter: parent.verticalCenter }
            Rectangle { width: 4; height: 4; radius: 2; color: Colors.withAlpha(Colors.rosewater, 0.6) }
            Rectangle { width: 20; height: 1; color: Colors.withAlpha(Colors.lavender, 0.4); anchors.verticalCenter: parent.verticalCenter }
        }

        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: clockText.bottom
            anchors.topMargin: 28
            text: root.currentDate
            font.family: Typography.displayFamily
            font.pixelSize: Typography.lockDateSize
            font.weight: Typography.lockDateWeight
            font.italic: true
            font.letterSpacing: Typography.lockDateSpacing
            color: Colors.subtext0
        }

        Item {
            id: inputField
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dateText.bottom
            anchors.topMargin: 55
            width: 220
            height: 44

            TextInput {
                id: passwordInput
                width: 1
                height: 1
                opacity: 0
                echoMode: TextInput.Normal
                focus: true

                text: root.context !== null ? root.context.password : ""
                onTextChanged: {
                    if (root.context !== null) {
                        root.context.password = text
                    }
                }

                onAccepted: {
                    if (root.context !== null) {
                        root.context.submitPassword()
                    }
                }
            }

            Row {
                id: dotRow
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -4
                spacing: 6

                Repeater {
                    id: dotRepeater
                    model: 24

                    Rectangle {
                        required property int index

                        property bool active: index < passwordInput.text.length
                        property bool isNewest: index === passwordInput.text.length - 1

                        width: 5
                        height: 5
                        radius: 2.5
                        color: Colors.text
                        visible: active
                        opacity: active ? 0.8 : 0.0
                        scale: active ? 1.0 : 0.5

                        Behavior on scale {
                            NumberAnimation { duration: 180; easing.type: Easing.OutBack }
                        }
                        Behavior on opacity {
                            NumberAnimation { duration: 120 }
                        }

                        // pulse the newest dot
                        SequentialAnimation on scale {
                            id: pulseAnim
                            running: false
                            NumberAnimation { to: 1.6; duration: 100; easing.type: Easing.OutQuad }
                            NumberAnimation { to: 1.0; duration: 200; easing.type: Easing.OutElastic }
                        }

                        onActiveChanged: {
                            if (active && isNewest) {
                                pulseAnim.restart()
                            }
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -4
                visible: passwordInput.text.length === 0
                text: "·  ·  ·"
                font.family: Typography.displayFamily
                font.pixelSize: Typography.lockDateSize
                font.letterSpacing: 2
                color: Colors.overlay0
                opacity: 0.4
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: passwordInput.activeFocus ? parent.width * 0.5 : parent.width * 0.3
                height: 1
                color: {
                    if (root.context !== null && root.context.authFailed) {
                        return Colors.red
                    }
                    return Colors.withAlpha(Colors.lavender, passwordInput.activeFocus ? 0.5 : 0.2)
                }

                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
                Behavior on color { ColorAnimation { duration: 250 } }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: inputField.bottom
            anchors.topMargin: 28
            font.family: Typography.displayFamily
            font.pixelSize: Typography.lockHintSize
            font.italic: true
            opacity: 0.6

            text: {
                if (root.context !== null && root.context.authFailed) {
                    return "incorrect"
                }
                if (root.context !== null && root.context.isAuthenticating) {
                    return "..."
                }
                return "↵"
            }

            color: {
                if (root.context !== null && root.context.authFailed) {
                    return Colors.red
                }
                return Colors.overlay1
            }

            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }
}
