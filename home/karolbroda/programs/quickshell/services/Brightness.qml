pragma Singleton

import QtQuick
import Quickshell
import qs.core

Singleton {
    id: root

    property real brightness: 0.5
    readonly property real increment: 0.1

    readonly property string icon: {
        if (brightness <= 0.15) return "moon"
        if (brightness <= 0.5) return "sun-dim"
        return "sun"
    }

    function setBrightness(value: real): void {
        const percent = Math.round(Math.max(0, Math.min(1, value)) * 100)
        if (percent === Math.round(root.brightness * 100)) return
        root.brightness = percent / 100
        job.run(["brightnessctl", "-m", "s", percent + "%"], null)
    }

    function increaseBrightness(): void {
        setBrightness(brightness + increment)
    }

    function decreaseBrightness(): void {
        setBrightness(brightness - increment)
    }

    function _parse(line: string): real {
        const parts = line.trim().split(",")
        const current = parseInt(parts[2], 10)
        const max = parseInt(parts[4], 10)
        return max > 0 && !isNaN(current) ? current / max : NaN
    }

    Job {
        id: job

        timeout: 5000
        onFinished: (tag, output, exitCode) => {
            const value = root._parse(output)
            if (exitCode === 0 && !isNaN(value)) root.brightness = value
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: job.poll(["brightnessctl", "-m"], null)
    }
}
