import QtQuick
import qs.theme
import qs.core
import qs.services
import qs.widgets.buttons
import qs.widgets.indicators

Item {
    id: root

    implicitWidth: Spacing.barHeight - 4
    implicitHeight: Spacing.barHeight - 4

    IconButton {
        anchors.fill: parent
        icon: "bell"
        iconSize: Spacing.iconMd

        onClicked: {
            Dispatcher.dispatch(Actions.togglePanel("notifications"))
        }
    }

    Badge {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 2
        count: {
            if (Notifs.list === null || Notifs.list === undefined) {
                return 0
            }
            return Notifs.list.length
        }
    }
}
