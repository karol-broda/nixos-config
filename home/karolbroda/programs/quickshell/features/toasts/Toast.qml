import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.icons
import qs.widgets.text
import qs.widgets.buttons
import qs.widgets.indicators

Item {
    id: root

    property var notification: null
    property bool showDivider: false

    property bool _entered: false
    property bool _exiting: false
    property bool _fullDismiss: false

    signal exitStarted()
    signal exitDone(bool fullDismiss)

    Layout.fillWidth: true
    implicitHeight: column.implicitHeight
    opacity: _entered && !_exiting ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: root._exiting ? Motion.panelCloseDuration : Motion.panelOpenDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root._exiting ? Motion.curveExit : Motion.curveSlide
        }
    }

    transform: Translate {
        x: root._entered && !root._exiting ? 0 : 40

        Behavior on x {
            NumberAnimation {
                duration: root._exiting ? Motion.panelCloseDuration : Motion.panelOpenDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root._exiting ? Motion.curveExit : Motion.curveSlide
            }
        }
    }

    Timer {
        id: _enterTimer
        interval: 16
        running: true
        onTriggered: root._entered = true
    }

    Timer {
        id: _autoHideTimer
        interval: {
            var baseTimeout = 5000
            if (root.notification !== null && root.notification !== undefined
                && root.notification.notification !== null && root.notification.notification !== undefined
                && root.notification.notification.expireTimeout > 0) {
                baseTimeout = root.notification.notification.expireTimeout
            }
            return Math.max(500, baseTimeout - Motion.panelOpenDuration)
        }
        running: root.notification !== null && root._entered && !root._exiting
        onTriggered: {
            root._fullDismiss = false
            root._startExit()
        }
    }

    Timer {
        id: _exitTimer
        interval: Motion.panelCloseDuration + 50
        onTriggered: root.exitDone(root._fullDismiss)
    }

    function _startExit() {
        if (root._exiting) return
        root._exiting = true
        _exitTimer.restart()
        root.exitStarted()
    }

    function dismissNotification() {
        root._fullDismiss = true
        root._startExit()
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Spacing.spacingSm

        Separator {
            Layout.fillWidth: true
            Layout.bottomMargin: Spacing.spacingXs
            visible: root.showDivider && !root._exiting
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingSm

            AppIcon {
                iconName: {
                    if (root.notification === null || root.notification === undefined) return ""
                    return root.notification.appIcon || ""
                }
                size: Spacing.iconSm
            }

            Label {
                Layout.fillWidth: true
                text: {
                    if (root.notification === null || root.notification === undefined) return ""
                    return root.notification.appName || "Unknown"
                }
                color: Colors.textMuted
                font.pixelSize: Typography.sizeCaption
            }

            Label {
                text: {
                    if (root.notification === null || root.notification === undefined) return "now"
                    return root.notification.timeStr || "now"
                }
                color: Colors.textDim
                font.pixelSize: Typography.sizeCaption
            }

            IconButton {
                icon: "x"
                size: 24
                iconSize: Spacing.iconSm
                onClicked: root.dismissNotification()
            }
        }

        Heading {
            Layout.fillWidth: true
            text: {
                if (root.notification === null || root.notification === undefined) return ""
                return root.notification.summary || ""
            }
            visible: text !== ""
            wrapMode: Text.Wrap
            maximumLineCount: 2
        }

        Body {
            Layout.fillWidth: true
            text: {
                if (root.notification === null || root.notification === undefined) return ""
                return root.notification.body || ""
            }
            visible: text !== ""
            wrapMode: Text.Wrap
            maximumLineCount: 3
            color: Colors.textSecondary
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingSm
            visible: {
                if (root.notification === null || root.notification === undefined) return false
                var actions = root.notification.actions
                return actions !== null && actions !== undefined && actions.length > 0
            }

            Repeater {
                model: {
                    if (root.notification === null || root.notification === undefined) return []
                    return root.notification.actions || []
                }

                TextButton {
                    required property var modelData

                    text: modelData.text || ""
                    onClicked: {
                        if (modelData.invoke !== null && modelData.invoke !== undefined && typeof modelData.invoke === "function") {
                            modelData.invoke()
                            root.dismissNotification()
                        }
                    }
                }
            }
        }
    }
}
