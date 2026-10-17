pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property int barCount: 32
    readonly property list<real> values: _values
    property int users: 0

    readonly property real smoothing: 0.35

    property list<real> _values: Array(barCount).fill(0)

    readonly property string _config: [
        "[general]",
        "framerate=60",
        "bars=" + barCount,
        "sleep_timer=3",
        "sensitivity=200",
        "[output]",
        "channels=mono",
        "method=raw",
        "raw_target=/dev/stdout",
        "data_format=ascii",
        "ascii_max_range=100"
    ].join("\n")

    Process {
        id: proc

        running: root.users > 0
        command: ["sh", "-c", "printf '%s' \"$1\" | exec cava -p /dev/stdin", "cava", root._config]

        onRunningChanged: if (!running) root._values = Array(root.barCount).fill(0)

        stdout: SplitParser {
            onRead: line => {
                const parsed = line.split(";").filter(v => v !== "").map(v => parseInt(v, 10))
                if (parsed.length !== root.barCount || parsed.some(isNaN)) return
                const k = root.smoothing
                root._values = parsed.map((v, i) => root._values[i] * k + v * (1 - k))
            }
        }
    }
}
