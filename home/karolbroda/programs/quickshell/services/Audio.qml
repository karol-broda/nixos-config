pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var nodes: Pipewire.nodes.values.reduce((acc, node) => {
        if (node !== null && node !== undefined && node.isStream !== true) {
            if (node.isSink === true) {
                acc.sinks.push(node)
            } else if (node.audio === true) {
                acc.sources.push(node)
            }
        }
        return acc
    }, { sources: [], sinks: [] })

    readonly property list<PwNode> sinks: nodes.sinks
    readonly property list<PwNode> sources: nodes.sources

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: {
        if (sink === null || sink === undefined) return false
        if (sink.audio === null || sink.audio === undefined) return false
        return sink.audio.muted === true
    }

    readonly property real volume: {
        if (sink === null || sink === undefined) return 0
        if (sink.audio === null || sink.audio === undefined) return 0
        return sink.audio.volume || 0
    }

    readonly property string icon: {
        if (muted) return "speaker-slash"
        if (volume <= 0) return "speaker-none"
        if (volume < 0.33) return "speaker-low"
        if (volume < 0.66) return "speaker-high"
        return "speaker-high"
    }

    function setVolume(newVolume: real): void {
        if (sink === null || sink === undefined) return
        if (sink.audio === null || sink.audio === undefined) return
        sink.audio.volume = Math.max(0, Math.min(1, newVolume))
    }

    function incrementVolume(amount: real): void {
        var delta = amount
        if (delta === null || delta === undefined || delta === 0) {
            delta = 0.05
        }
        setVolume(volume + delta)
    }

    function decrementVolume(amount: real): void {
        var delta = amount
        if (delta === null || delta === undefined || delta === 0) {
            delta = 0.05
        }
        setVolume(volume - delta)
    }

    function toggleMute(): void {
        if (sink === null || sink === undefined) return
        if (sink.audio === null || sink.audio === undefined) return
        sink.audio.muted = sink.audio.muted !== true
    }

    function setAudioSink(newSink: PwNode): void {
        Pipewire.preferredDefaultAudioSink = newSink
    }

    function setAudioSource(newSource: PwNode): void {
        Pipewire.preferredDefaultAudioSource = newSource
    }

    PwObjectTracker {
        objects: [...root.sinks, ...root.sources]
    }
}
