pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property bool available: true
    readonly property bool hasPerformance: PowerProfiles.hasPerformanceProfile
    readonly property int profile: PowerProfiles.profile
    readonly property bool isPerformance: profile === PowerProfile.Performance
    readonly property bool isBalanced: profile === PowerProfile.Balanced
    readonly property bool isPowerSaver: profile === PowerProfile.PowerSaver

    readonly property string icon: {
        if (profile === PowerProfile.Performance) {
            return "rocket-launch";
        }
        if (profile === PowerProfile.PowerSaver) {
            return "leaf";
        }
        return "scales";
    }

    readonly property string profileName: {
        if (profile === PowerProfile.Performance) {
            return "performance";
        }
        if (profile === PowerProfile.PowerSaver) {
            return "power saver";
        }
        return "balanced";
    }

    readonly property string profileDescription: {
        if (profile === PowerProfile.Performance) {
            return "maximum performance";
        }
        if (profile === PowerProfile.PowerSaver) {
            return "extended battery life";
        }
        return "balance of power and performance";
    }

    function setPerformance() {
        if (hasPerformance) {
            PowerProfiles.profile = PowerProfile.Performance;
        }
    }

    function setBalanced() {
        PowerProfiles.profile = PowerProfile.Balanced;
    }

    function setPowerSaver() {
        PowerProfiles.profile = PowerProfile.PowerSaver;
    }

    function cycleProfile() {
        if (profile === PowerProfile.PowerSaver) {
            setBalanced();
        } else if (profile === PowerProfile.Balanced) {
            if (hasPerformance) {
                setPerformance();
            } else {
                setPowerSaver();
            }
        } else {
            setPowerSaver();
        }
    }

    function iconForProfile(p) {
        if (p === PowerProfile.Performance) {
            return "rocket-launch";
        }
        if (p === PowerProfile.PowerSaver) {
            return "leaf";
        }
        return "scales";
    }

    function nameForProfile(p) {
        if (p === PowerProfile.Performance) {
            return "performance";
        }
        if (p === PowerProfile.PowerSaver) {
            return "power saver";
        }
        return "balanced";
    }

    function logout() {
        logoutProc.running = true;
    }

    function suspend() {
        suspendProc.running = true;
    }

    function reboot() {
        rebootProc.running = true;
    }

    function shutdown() {
        shutdownProc.running = true;
    }

    Process {
        id: logoutProc
        command: ["hyprctl", "dispatch", "exit"]
    }

    Process {
        id: suspendProc
        command: ["systemctl", "suspend"]
    }

    Process {
        id: rebootProc
        command: ["systemctl", "reboot"]
    }

    Process {
        id: shutdownProc
        command: ["systemctl", "poweroff"]
    }
}
