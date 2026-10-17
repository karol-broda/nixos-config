pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property UPowerDevice _device: UPower.displayDevice
    readonly property bool available: (_device?.ready ?? false) && (_device?.isLaptopBattery ?? false)
    readonly property real percentage: available ? Math.max(0, Math.min(100, _device.percentage * 100)) : 0
    readonly property int percentageInt: Math.round(percentage)
    readonly property bool charging: available && [UPowerDeviceState.Charging, UPowerDeviceState.PendingCharge].includes(_device.state)
    readonly property bool fullyCharged: available && _device.state === UPowerDeviceState.FullyCharged
    readonly property bool pluggedIn: available && (charging || fullyCharged)
    readonly property bool onBattery: UPower.onBattery
    readonly property bool isLow: available && percentage < 20 && !charging
    readonly property bool isCritical: available && percentage < 10 && !charging
    readonly property real health: available && _device.healthSupported ? _device.healthPercentage : 0
    readonly property real powerRate: available ? Math.abs(_device.changeRate) : 0

    readonly property string icon: {
        if (!available) return "battery-warning"
        if (charging || fullyCharged) return "battery-charging"
        if (percentage < 10) return "battery-empty"
        if (percentage < 25) return "battery-low"
        if (percentage < 50) return "battery-medium"
        if (percentage < 75) return "battery-high"
        return "battery-full"
    }

    readonly property string timeRemaining: {
        if (!available) return ""
        if (charging) return root._formatTime(_device.timeToFull)
        return onBattery ? root._formatTime(_device.timeToEmpty) : ""
    }

    readonly property string statusText: {
        if (!available) return "no battery"
        if (fullyCharged) return "fully charged"
        if (charging) return timeRemaining ? "charging · " + timeRemaining + " until full" : "charging"
        if (onBattery) return timeRemaining ? timeRemaining + " remaining" : "on battery"
        return "plugged in"
    }

    function _formatTime(seconds: real): string {
        if (!isFinite(seconds) || seconds <= 0) return ""
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor(seconds % 3600 / 60)
        return hours > 0 ? hours + "h " + minutes + "m" : minutes + "m"
    }
}
