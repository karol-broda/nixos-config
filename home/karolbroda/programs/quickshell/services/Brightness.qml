pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property real brightness: 0.5

    readonly property string icon: {
        if (brightness <= 0.15) {
            return "moon";
        }
        if (brightness <= 0.50) {
            return "sun-dim";
        }
        return "sun";
    }

    readonly property real increment: 0.1

    function setBrightness(value: real): void {
        var clamped = Math.max(0, Math.min(1, value));
        var rounded = Math.round(clamped * 100);

        if (Math.round(brightness * 100) === rounded) {
            return;
        }

        brightness = clamped;

        setProcess.command = ["brightnessctl", "s", rounded + "%"];
        setProcess.running = true;
    }

    function increaseBrightness(): void {
        setBrightness(brightness + increment);
    }

    function decreaseBrightness(): void {
        setBrightness(brightness - increment);
    }

    Component.onCompleted: {
        pollProcess.running = true;
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!pollProcess.running && !setProcess.running) {
                pollProcess.running = true;
            }
        }
    }

    Process {
        id: pollProcess

        command: ["sh", "-c", "echo $(brightnessctl g) $(brightnessctl m)"]

        stdout: SplitParser {
            onRead: function(data) {
                var parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    var current = parseInt(parts[0]);
                    var max = parseInt(parts[1]);
                    if (max > 0 && !isNaN(current) && !isNaN(max)) {
                        var newBrightness = current / max;
                        if (Math.round(newBrightness * 100) !== Math.round(root.brightness * 100)) {
                            root.brightness = newBrightness;
                        }
                    }
                }
            }
        }
    }

    Process {
        id: setProcess

        command: []
    }
}
