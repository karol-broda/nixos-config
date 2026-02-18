import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
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

        IconButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            icon: "lock-simple"

            onClicked: {
                Dispatcher.dispatch(Actions.lock())
                Dispatcher.dispatch(Actions.closePanel())
            }
        }

        IconButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            icon: "sign-out"

            onClicked: {
                Dispatcher.dispatch(Actions.logout())
            }
        }

        IconButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            icon: "moon"

            onClicked: {
                Dispatcher.dispatch(Actions.suspend())
                Dispatcher.dispatch(Actions.closePanel())
            }
        }

        IconButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            icon: "arrow-counter-clockwise"

            onClicked: {
                Dispatcher.dispatch(Actions.reboot())
            }
        }

        IconButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            icon: "power"

            onClicked: {
                Dispatcher.dispatch(Actions.shutdown())
            }
        }
    }
}
