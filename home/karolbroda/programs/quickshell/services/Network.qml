pragma Singleton

import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
    id: root

    property int users: 0

    readonly property WifiDevice _wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property WifiNetwork _activeNetwork: _wifiDevice?.networks.values.find(n => n.connected) ?? null
    readonly property bool ready: _wifiDevice !== null
    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property bool connected: _wifiDevice?.connected ?? false
    readonly property string ssid: _activeNetwork?.name ?? ""
    readonly property real strength: Math.max(0, Math.min(1, _activeNetwork?.signalStrength ?? 0))
    readonly property string icon: wifiEnabled && connected ? root.signalIcon(strength) : "wifi-slash"
    readonly property list<WifiNetwork> networks: (_wifiDevice?.networks.values ?? [])
        .filter(n => n.name.trim() !== "")
        .sort((a, b) => Number(b.connected) - Number(a.connected) || b.signalStrength - a.signalStrength)

    Binding {
        target: root._wifiDevice
        property: "scannerEnabled"
        value: root.users > 0
        when: root._wifiDevice !== null
    }

    function toggleWifi(): void {
        root.setWifiEnabled(!root.wifiEnabled)
    }

    function setWifiEnabled(enabled: bool): void {
        Networking.wifiEnabled = enabled
    }

    function connectTo(network: WifiNetwork): void {
        if (network) network.connect()
    }

    function disconnect(): void {
        root._activeNetwork?.disconnect()
    }

    function signalIcon(value: real): string {
        if (value < 0.30) return "wifi-low"
        return value < 0.60 ? "wifi-medium" : "wifi-high"
    }
}
