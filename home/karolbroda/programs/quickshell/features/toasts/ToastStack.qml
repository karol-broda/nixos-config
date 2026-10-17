pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.theme
import qs.services
import qs.widgets.containers
import qs.widgets.indicators

Item {
    id: root

    implicitWidth: 360
    implicitHeight: list.contentHeight + Spacing.panelPadding * 2

    ListView {
        id: list

        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        interactive: false
        spacing: Spacing.spacingMd

        model: ScriptModel {
            values: [...Notifs.popups]
        }

        delegate: Column {
            id: toast

            required property var modelData
            required property int index

            width: list.width
            spacing: Spacing.spacingSm

            Separator {
                width: parent.width
                visible: toast.index > 0
            }

            NotificationContent {
                width: parent.width
                notif: toast.modelData
                bodyLines: 3
                compact: true
                onDismissRequested: Notifs.dismiss(toast.modelData)
                onActionInvoked: action => Notifs.invokeAction(toast.modelData, action)
            }
        }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Motion.durationMedium }
            NumberAnimation { property: "x"; from: 40; to: 0; duration: Motion.panelOpenDuration; easing.type: Easing.OutCubic }
        }
        remove: Transition {
            NumberAnimation { property: "opacity"; to: 0; duration: Motion.durationFast }
            NumberAnimation { property: "x"; to: 40; duration: Motion.panelCloseDuration; easing.type: Easing.InCubic }
        }
        displaced: Transition {
            NumberAnimation { property: "y"; duration: Motion.durationMedium; easing.type: Easing.OutCubic }
        }
    }
}
