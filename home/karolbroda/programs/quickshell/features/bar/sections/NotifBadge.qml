import QtQuick
import qs.theme
import qs.services
import qs.widgets.indicators

Item {
    id: root

    property var screen: null

    implicitWidth: Spacing.barHeight - 4
    implicitHeight: Spacing.barHeight - 4

    PanelButton {
        anchors.fill: parent
        panel: "notifications"
        icon: "bell"
        screen: root.screen
    }

    Badge {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 2
        count: Notifs.count
    }
}
