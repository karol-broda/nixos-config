pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property bool hasPerformance: PowerProfiles.hasPerformanceProfile
    readonly property int profile: PowerProfiles.profile

    readonly property string icon: iconForProfile(profile)
    readonly property string profileName: nameForProfile(profile)

    function iconForProfile(p: int): string {
        if (p === PowerProfile.Performance) return "rocket-launch"
        if (p === PowerProfile.PowerSaver) return "leaf"
        return "scales"
    }

    function nameForProfile(p: int): string {
        if (p === PowerProfile.Performance) return "performance"
        if (p === PowerProfile.PowerSaver) return "power saver"
        return "balanced"
    }

    function setProfile(p: int): void {
        if (p === PowerProfile.Performance && !root.hasPerformance) return
        PowerProfiles.profile = p
    }

    function cycleProfile(): void {
        if (profile === PowerProfile.PowerSaver) setProfile(PowerProfile.Balanced)
        else if (profile === PowerProfile.Balanced && hasPerformance) setProfile(PowerProfile.Performance)
        else setProfile(PowerProfile.PowerSaver)
    }

    function logout(): void {
        Hypr.exit()
    }

    function suspend(): void {
        Env.launch(["systemctl", "suspend"])
    }

    function reboot(): void {
        Env.launch(["systemctl", "reboot"])
    }

    function shutdown(): void {
        Env.launch(["systemctl", "poweroff"])
    }
}
