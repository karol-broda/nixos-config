import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.buttons

GridLayout {
    id: root

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
        icon: "bluetooth"
        label: "Bluetooth"
        isOn: false
        enabled: false
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
