pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
    id: root

    readonly property string kind: _kind
    readonly property string shownKind: _shownKind

    property string _kind: ""
    property string _shownKind: "volume"
    property bool _ready: false

    function show(kind: string): void {
        if (!root._ready) return
        root._kind = kind
        root._shownKind = kind
        hideTimer.interval = kind === "battery" ? 2500 : 1500
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        onTriggered: root._kind = ""
    }

    Timer {
        interval: 1000
        running: true
        onTriggered: root._ready = true
    }

    Connections {
        target: Audio

        function onVolumeChanged(): void {
            root.show("volume")
        }

        function onMutedChanged(): void {
            root.show("volume")
        }
    }

    Connections {
        target: Brightness

        function onBrightnessChanged(): void {
            root.show("brightness")
        }
    }

    Connections {
        target: Battery

        function onPluggedInChanged(): void {
            root.show("battery")
        }
    }
}
