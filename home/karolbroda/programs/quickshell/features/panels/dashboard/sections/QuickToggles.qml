import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.buttons

ColumnLayout {
    id: root

    property bool active: false

    property string expandedSection: ""

    onActiveChanged: if (!active) expandedSection = ""

    function toggleSection(name: string): void {
        root.expandedSection = root.expandedSection === name ? "" : name
    }

    spacing: Spacing.spacingSm

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: Spacing.spacingSm
        columnSpacing: Spacing.spacingSm

        ToggleButton {
            Layout.fillWidth: true
            icon: Network.icon
            label: "WiFi"
            isOn: Network.wifiEnabled
            onToggled: Network.toggleWifi()
        }

        ToggleButton {
            Layout.fillWidth: true
            icon: Bluetooth.icon
            label: "Bluetooth"
            isOn: Bluetooth.enabled
            onToggled: Bluetooth.togglePower()
        }

        ToggleButton {
            Layout.fillWidth: true
            icon: "moon"
            label: "Night"
            enabled: false
        }

        ToggleButton {
            Layout.fillWidth: true
            icon: "bell-slash"
            label: "DND"
            enabled: false
        }
    }

    NetworkDetail {
        Layout.fillWidth: true
        expanded: root.active && root.expandedSection === "wifi"
        onToggled: root.toggleSection("wifi")
    }

    BluetoothDetail {
        Layout.fillWidth: true
        expanded: root.active && root.expandedSection === "bluetooth"
        onToggled: root.toggleSection("bluetooth")
    }
}
