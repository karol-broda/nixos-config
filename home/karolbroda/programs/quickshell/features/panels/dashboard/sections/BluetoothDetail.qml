pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.containers

ExpandableSection {
    id: root

    readonly property bool hasConnected: Bluetooth.connectedDevices.length > 0

    visible: Bluetooth.enabled
    icon: Bluetooth.icon
    iconState: hasConnected ? "active" : "default"
    title: Bluetooth.statusText
    titleColor: hasConnected ? Colors.textPrimary : Colors.textMuted

    Repeater {
        model: Bluetooth.knownDevices

        ChoiceRow {
            required property var modelData

            readonly property bool hasBattery: modelData.batteryAvailable === true

            Layout.fillWidth: true
            icon: Bluetooth.deviceIcon(modelData.icon ?? "")
            title: modelData.name
            subtitle: hasBattery ? Math.round(modelData.battery * 100) + "%" : ""
            trailing: Bluetooth.deviceStatus(modelData)
            selected: modelData.connected === true
            onClicked: Bluetooth.toggleDevice(modelData)
        }
    }
}
