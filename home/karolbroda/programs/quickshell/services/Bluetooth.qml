pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import QtQuick

Singleton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter ?? null

    readonly property bool ready: adapter !== null && adapter !== undefined
    readonly property bool enabled: ready && adapter.enabled === true
    readonly property bool discovering: ready && adapter.discovering === true

    readonly property var connectedDevices: {
        if (!ready) return []
        var result = []
        var devs = Bluetooth.devices.values
        for (var i = 0; i < devs.length; i++) {
            if (devs[i] !== null && devs[i] !== undefined && devs[i].connected === true) {
                result.push(devs[i])
            }
        }
        return result
    }

    readonly property var pairedDevices: {
        if (!ready) return []
        var result = []
        var devs = Bluetooth.devices.values
        for (var i = 0; i < devs.length; i++) {
            if (devs[i] !== null && devs[i] !== undefined && devs[i].paired === true && devs[i].connected !== true) {
                result.push(devs[i])
            }
        }
        return result
    }

    readonly property var deviceModel: {
        if (!ready) return []
        return Bluetooth.devices.values
    }

    readonly property string icon: {
        if (!ready) return "bluetooth"
        if (!enabled) return "bluetooth-slash"
        if (connectedDevices.length > 0) return "bluetooth-connected"
        return "bluetooth"
    }

    readonly property string statusText: {
        if (!enabled) return "Off"
        if (connectedDevices.length === 1) return connectedDevices[0].name || "Connected"
        if (connectedDevices.length > 1) return connectedDevices.length + " connected"
        return "On"
    }

    reloadableId: "bluetooth"

    function togglePower(): void {
        if (adapter !== null && adapter !== undefined) {
            adapter.enabled = !adapter.enabled
        }
    }

    function toggleDiscovery(): void {
        if (adapter !== null && adapter !== undefined) {
            adapter.discovering = !adapter.discovering
        }
    }

    function startDiscovery(): void {
        if (adapter !== null && adapter !== undefined) {
            adapter.discovering = true
        }
    }

    function stopDiscovery(): void {
        if (adapter !== null && adapter !== undefined) {
            adapter.discovering = false
        }
    }

    function connectDevice(device): void {
        if (device !== null && device !== undefined) {
            device.connected = true
        }
    }

    function disconnectDevice(device): void {
        if (device !== null && device !== undefined) {
            device.connected = false
        }
    }

    function toggleDevice(device): void {
        if (device !== null && device !== undefined) {
            device.connected = !device.connected
        }
    }

    function deviceIcon(iconName): string {
        if (iconName === null || iconName === undefined) return "bluetooth"
        switch (iconName) {
            case "audio-headphones":
            case "audio-headset":
                return "headphones"
            case "audio-card":
            case "audio-speakers":
                return "speaker-high"
            case "input-keyboard":
                return "keyboard"
            case "input-mouse":
                return "mouse"
            case "input-gaming":
                return "game-controller"
            case "input-tablet":
                return "device-tablet"
            case "phone":
                return "device-mobile-speaker"
            case "computer":
                return "laptop"
            case "video-display":
                return "monitor"
            default:
                return "bluetooth"
        }
    }
}
