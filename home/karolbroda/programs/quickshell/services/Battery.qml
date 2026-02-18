pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property UPowerDevice device: UPower.displayDevice
    readonly property bool available: device.ready && device.isLaptopBattery
    readonly property real percentage: available ? device.percentage * 100 : 0
    readonly property int percentageInt: Math.round(percentage)

    readonly property bool charging: {
        if (!available) {
            return false;
        }
        var s = device.state;
        return s === UPowerDeviceState.Charging || s === UPowerDeviceState.PendingCharge;
    }

    readonly property bool fullyCharged: available && device.state === UPowerDeviceState.FullyCharged
    readonly property bool onBattery: UPower.onBattery
    readonly property real timeToEmpty: available ? device.timeToEmpty : 0
    readonly property real timeToFull: available ? device.timeToFull : 0
    readonly property real health: available && device.healthSupported ? device.healthPercentage : 100
    readonly property real powerRate: available ? Math.abs(device.changeRate) : 0
    readonly property bool isLow: percentage < 20 && !charging
    readonly property bool isCritical: percentage < 10 && !charging

    readonly property string icon: {
        if (!available) {
            return "battery-warning";
        }
        if (charging || fullyCharged) {
            return "battery-charging";
        }
        if (percentage < 10) {
            return "battery-empty";
        }
        if (percentage < 25) {
            return "battery-low";
        }
        if (percentage < 50) {
            return "battery-medium";
        }
        if (percentage < 75) {
            return "battery-high";
        }
        return "battery-full";
    }

    function formatTime(seconds) {
        if (seconds <= 0 || isNaN(seconds)) {
            return "";
        }
        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);
        if (hours > 0) {
            return hours + "h " + minutes + "m";
        }
        return minutes + "m";
    }

    readonly property string timeRemaining: {
        if (charging) {
            return formatTime(timeToFull);
        }
        if (onBattery) {
            return formatTime(timeToEmpty);
        }
        return "";
    }

    readonly property string statusText: {
        if (!available) {
            return "no battery";
        }
        if (fullyCharged) {
            return "fully charged";
        }
        if (charging) {
            var t = formatTime(timeToFull);
            if (t !== "") {
                return "charging · " + t + " until full";
            }
            return "charging";
        }
        if (onBattery) {
            var t = formatTime(timeToEmpty);
            if (t !== "") {
                return t + " remaining";
            }
            return "on battery";
        }
        return "plugged in";
    }
}
