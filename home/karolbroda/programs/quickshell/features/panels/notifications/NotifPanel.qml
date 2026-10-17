pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.services
import qs.widgets.containers
import qs.widgets.icons
import qs.widgets.text
import "sections"

Item {
    id: root

    implicitWidth: 360
    implicitHeight: content.implicitHeight + Spacing.panelPadding * 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        NotifHeader {
            Layout.fillWidth: true
            count: Notifs.count
            onClearAll: Notifs.clearAll()
        }

        ListView {
            id: list

            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(400, contentHeight)
            visible: count > 0
            spacing: Spacing.spacingSm
            clip: true
            interactive: contentHeight > height

            model: ScriptModel {
                values: [...Notifs.list].reverse()
            }

            delegate: Card {
                id: card

                required property var modelData

                width: list.width
                implicitHeight: body.implicitHeight + Spacing.paddingMd * 2

                NotificationContent {
                    id: body
                    anchors.left: parent.left
                    anchors.right: parent.right
                    notif: card.modelData
                    onDismissRequested: Notifs.dismiss(card.modelData)
                    onActionInvoked: action => Notifs.invokeAction(card.modelData, action)
                }
            }

            remove: Transition {
                NumberAnimation { property: "opacity"; to: 0; duration: Motion.durationFast }
            }
            displaced: Transition {
                NumberAnimation { property: "y"; duration: Motion.durationMedium; easing.type: Easing.OutCubic }
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            visible: Notifs.count === 0
            topPadding: Spacing.spacingLg
            spacing: Spacing.spacingSm

            DuotoneIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                name: "bell-slash"
                size: Spacing.iconXl
                iconState: "disabled"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No notifications"
                color: Colors.textDim
            }
        }
    }
}
