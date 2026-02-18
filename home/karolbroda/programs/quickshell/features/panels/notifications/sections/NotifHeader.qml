import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.text
import qs.widgets.buttons

RowLayout {
    id: root

    property int count: 0

    signal clearAll()

    spacing: Spacing.spacingSm

    Title {
        Layout.fillWidth: true
        text: "Notifications"
    }

    Label {
        text: root.count + " notification" + (root.count !== 1 ? "s" : "")
        visible: root.count > 0
    }

    TextButton {
        text: "Clear all"
        visible: root.count > 0
        onClicked: root.clearAll()
    }
}
