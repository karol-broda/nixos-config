import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.state
import qs.widgets.buttons
import qs.widgets.text

ColumnLayout {
    id: root

    spacing: Spacing.spacingSm

    Label {
        text: "Power"
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Spacing.spacingSm

        Repeater {
            model: [
                { icon: "lock-simple", run: () => Shell.lock() },
                { icon: "sign-out", run: () => Power.logout() },
                { icon: "moon", run: () => { Shell.closePanel(); Power.suspend() } },
                { icon: "arrow-counter-clockwise", run: () => Power.reboot() },
                { icon: "power", run: () => Power.shutdown() }
            ]

            IconButton {
                required property var modelData

                Layout.fillWidth: true
                Layout.preferredHeight: 40
                icon: modelData.icon
                onClicked: modelData.run()
            }
        }
    }
}
