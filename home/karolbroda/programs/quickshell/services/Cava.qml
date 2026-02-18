pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property int barCount: 32
    property list<real> values: Array(barCount).fill(0)
    property int refCount: 0

    readonly property real smoothing: 0.35

    function buildConfig() {
        const lines = [
            "[general]",
            "framerate=60",
            "bars=" + root.barCount,
            "sleep_timer=3",
            "sensitivity=200",
            "",
            "[output]",
            "channels=mono",
            "method=raw",
            "raw_target=/dev/stdout",
            "data_format=ascii",
            "ascii_max_range=100",
        ];
        return lines.join("\\n");
    }

    Process {
        id: cavaProc

        running: root.refCount > 0
        command: [
            "sh", "-c",
            "printf '" + root.buildConfig() + "' | cava -p /dev/stdin"
        ]

        stdout: SplitParser {
            onRead: data => {
                if (root.refCount <= 0) return;

                const parsed = data.slice(0, -1).split(";").map(v => parseInt(v, 10));
                if (parsed.length === 0) return;

                const prev = root.values;
                const smoothed = [];
                const k = root.smoothing;

                for (let i = 0; i < parsed.length; i++) {
                    const old = i < prev.length ? prev[i] : 0;
                    smoothed.push(old * k + parsed[i] * (1.0 - k));
                }

                root.values = smoothed;
            }
        }
    }
}
