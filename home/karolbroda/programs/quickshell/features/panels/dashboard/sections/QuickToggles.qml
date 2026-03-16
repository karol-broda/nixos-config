import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.buttons

ColumnLayout {
    id: root

    spacing: Spacing.spacingSm

    property string expandedSection: ""

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: Spacing.spacingSm
        columnSpacing: Spacing.spacingSm

        ToggleButton {
            Layout.fillWidth: true
            icon: Network.icon !== null && Network.icon !== undefined ? Network.icon : "wifi-high"
            label: "WiFi"
            isOn: Network.connected === true
            onToggled: Dispatcher.dispatch(Actions.toggleWifi())
        }

        ToggleButton {
            Layout.fillWidth: true
            icon: Bluetooth.icon !== null && Bluetooth.icon !== undefined ? Bluetooth.icon : "bluetooth"
            label: "Bluetooth"
            isOn: Bluetooth.enabled === true
            onToggled: Dispatcher.dispatch(Actions.toggleBluetooth())
        }

        ToggleButton {
            Layout.fillWidth: true
            icon: "moon"
            label: "Night"
            isOn: false
            enabled: false
        }

        ToggleButton {
            Layout.fillWidth: true
            icon: "bell-slash"
            label: "DND"
            isOn: false
            enabled: false
        }
    }

    NetworkDetail {
        Layout.fillWidth: true
        expanded: root.expandedSection === "wifi"
        onHeaderClicked: root.expandedSection = root.expandedSection === "wifi" ? "" : "wifi"
    }

    BluetoothDetail {
        Layout.fillWidth: true
        expanded: root.expandedSection === "bluetooth"
        onHeaderClicked: root.expandedSection = root.expandedSection === "bluetooth" ? "" : "bluetooth"
    }
}
