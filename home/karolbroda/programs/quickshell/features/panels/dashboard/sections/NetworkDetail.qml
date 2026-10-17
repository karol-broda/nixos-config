pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.core
import qs.theme
import qs.services
import qs.widgets.containers

ExpandableSection {
    id: root

    visible: Network.wifiEnabled
    icon: Network.icon
    iconState: Network.connected ? "active" : "default"
    title: Network.connected ? Network.ssid : "Not connected"
    titleColor: Network.connected ? Colors.textPrimary : Colors.textMuted

    Lease {
        target: Network
        active: root.expanded && root.visible
    }

    Repeater {
        model: Network.networks

        ChoiceRow {
            required property var modelData

            Layout.fillWidth: true
            icon: Network.signalIcon(modelData.signalStrength ?? 0)
            title: modelData.name
            selected: modelData.connected === true
            trailing: selected ? "Connected" : ""
            onClicked: selected ? Network.disconnect() : Network.connectTo(modelData)
        }
    }
}
