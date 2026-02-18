import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.text
import qs.widgets.icons
import "sections"

Panel {
    id: root

    slideFrom: "top-right"
    open: screenActive && Dispatcher.activePanel === "notifications"

    property bool screenActive: true

    targetWidth: 360
    targetHeight: content.implicitHeight + Spacing.panelPadding * 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        NotifHeader {
            Layout.fillWidth: true
            count: {
                if (Notifs.list === null || Notifs.list === undefined) return 0
                return Notifs.list.length
            }
            onClearAll: {
                Dispatcher.dispatch(Actions.clearAllNotifications())
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(400, notifList.implicitHeight)
            Layout.minimumHeight: 100

            NotifList {
                id: notifList
                anchors.fill: parent
                notifications: Notifs.list !== null && Notifs.list !== undefined ? Notifs.list : []
            }

            Column {
                anchors.centerIn: parent
                spacing: Spacing.spacingSm
                visible: Notifs.list === null || Notifs.list === undefined || Notifs.list.length === 0

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
}
