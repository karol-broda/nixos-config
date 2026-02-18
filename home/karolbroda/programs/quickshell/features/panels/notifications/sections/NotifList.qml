import QtQuick
import qs.theme

Item {
    id: root

    property var notifications: []

    implicitHeight: listView.contentHeight

    ListView {
        id: listView
        anchors.fill: parent
        model: root.notifications
        spacing: Spacing.spacingSm
        clip: true
        interactive: contentHeight > height

        delegate: NotifCard {
            required property var modelData
            required property int index

            width: listView.width
            notification: modelData
        }
    }
}
