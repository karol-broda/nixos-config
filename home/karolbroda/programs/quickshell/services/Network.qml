pragma Singleton

import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
    id: root

    readonly property var wifiDevice: {
        var devs = Networking.devices.values
        for (var i = 0; i < devs.length; i++) {
            if (devs[i] !== null && devs[i] !== undefined && devs[i].type === DeviceType.Wifi) {
                return devs[i]
            }
        }
        return null
    }

    readonly property var activeNetwork: {
        if (wifiDevice === null || wifiDevice === undefined) return null
        var nets = wifiDevice.networks.values
        for (var i = 0; i < nets.length; i++) {
            if (nets[i] !== null && nets[i] !== undefined && nets[i].connected === true) {
                return nets[i]
            }
        }
        return null
    }

    readonly property bool ready: wifiDevice !== null && wifiDevice !== undefined

    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property bool connected: ready && wifiDevice.connected === true
    readonly property bool scanning: ready && wifiDevice.scannerEnabled === true

    readonly property string ssid: {
        if (activeNetwork === null || activeNetwork === undefined) return ""
        return activeNetwork.name || ""
    }

    readonly property real strength: {
        if (activeNetwork === null || activeNetwork === undefined) return 0
        return activeNetwork.signalStrength
    }

    readonly property string icon: {
        if (!ready) return "wifi-high"
        if (wifiEnabled !== true) return "wifi-slash"
        if (!connected) return "wifi-slash"
        if (strength < 0.30) return "wifi-low"
        if (strength < 0.60) return "wifi-medium"
        return "wifi-high"
    }

    readonly property var networks: {
        if (wifiDevice === null || wifiDevice === undefined) return []
        return wifiDevice.networks.values
    }

    reloadableId: "network"

    function toggleWifi(): void {
        Networking.wifiEnabled = !Networking.wifiEnabled
    }

    function enableWifi(enabled: bool): void {
        Networking.wifiEnabled = enabled
    }

    function startScan(): void {
        if (wifiDevice !== null && wifiDevice !== undefined) {
            wifiDevice.scannerEnabled = true
        }
    }

    function stopScan(): void {
        if (wifiDevice !== null && wifiDevice !== undefined) {
            wifiDevice.scannerEnabled = false
        }
    }

    function connectToNetwork(network): void {
        if (network !== null && network !== undefined) {
            network.connect()
        }
    }

    function disconnectFromNetwork(): void {
        if (activeNetwork !== null && activeNetwork !== undefined) {
            activeNetwork.disconnect()
        }
    }
}
