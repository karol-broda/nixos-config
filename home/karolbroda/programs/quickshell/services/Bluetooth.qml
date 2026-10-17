pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property var _backend: Bluetooth
    readonly property var adapter: _backend.defaultAdapter ?? null
    readonly property bool ready: adapter !== null
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property bool discovering: adapter?.discovering ?? false
    readonly property list<BluetoothDevice> devices: adapter?.devices.values ?? []
    readonly property list<BluetoothDevice> connectedDevices: devices.filter(d => d.connected)
    readonly property list<BluetoothDevice> knownDevices: devices
        .filter(d => d.name.trim() !== "" && (d.connected || d.paired || d.trusted || d.bonded))
        .sort((a, b) => Number(b.connected) - Number(a.connected) || a.name.localeCompare(b.name))

    readonly property string icon: {
        if (!enabled) return ready ? "bluetooth-slash" : "bluetooth"
        return connectedDevices.length > 0 ? "bluetooth-connected" : "bluetooth"
    }

    readonly property string statusText: {
        if (!enabled) return "Off"
        if (connectedDevices.length === 1) return connectedDevices[0].name || "Connected"
        return connectedDevices.length > 1 ? connectedDevices.length + " connected" : "On"
    }

    function togglePower(): void {
        if (root.adapter) root.adapter.enabled = !root.adapter.enabled
    }

    function toggleDiscovery(): void {
        if (root.adapter) root.adapter.discovering = !root.adapter.discovering
    }

    function toggleDevice(device: BluetoothDevice): void {
        if (device && root.devices.includes(device)) device.connected = !device.connected
    }

    function deviceStatus(device: BluetoothDevice): string {
        if (device?.connected) return "Connected"
        if (device?.paired) return "Paired"
        if (device?.trusted) return "Trusted"
        return device?.bonded ? "Bonded" : ""
    }

    function deviceIcon(iconName: string): string {
        switch (iconName) {
        case "audio-headphones":
        case "audio-headset": return "headphones"
        case "audio-card":
        case "audio-speakers": return "speaker-high"
        case "input-keyboard": return "keyboard"
        case "input-mouse": return "mouse"
        case "input-gaming": return "game-controller"
        case "input-tablet": return "device-tablet"
        case "phone": return "device-mobile-speaker"
        case "computer": return "laptop"
        case "video-display": return "monitor"
        default: return "bluetooth"
        }
    }
}
