pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property list<PwNode> sinks: Pipewire.nodes.values.filter(n => !n.isStream && n.isSink && n.audio !== null)
    readonly property list<PwNode> sources: Pipewire.nodes.values.filter(n => !n.isStream && !n.isSink && n.audio !== null)
    readonly property PwNode sink: Pipewire.defaultAudioSink ?? null
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: Math.max(0, Math.min(1, sink?.audio?.volume ?? 0))
    readonly property string sinkName: sink?.description || sink?.name || "No output"
    readonly property real peak: sinkPeakMonitor.peak

    readonly property string icon: {
        if (muted) return "speaker-slash"
        if (volume <= 0) return "speaker-none"
        return volume < 0.5 ? "speaker-low" : "speaker-high"
    }

    function setVolume(value: real): void {
        if (root.sink?.audio && isFinite(value)) root.sink.audio.volume = Math.max(0, Math.min(1, value))
    }

    function incrementVolume(amount = 0.05): void {
        root.setVolume(root.volume + amount)
    }

    function decrementVolume(amount = 0.05): void {
        root.setVolume(root.volume - amount)
    }

    function toggleMute(): void {
        if (root.sink?.audio) root.sink.audio.muted = !root.sink.audio.muted
    }

    function setAudioSink(node: PwNode): void {
        Pipewire.preferredDefaultAudioSink = node
    }

    function setAudioSource(node: PwNode): void {
        Pipewire.preferredDefaultAudioSource = node
    }

    PwNodePeakMonitor {
        id: sinkPeakMonitor
        node: root.sink
        enabled: root.sink !== null
    }

    PwObjectTracker {
        objects: [...root.sinks, ...root.sources, root.sink].filter(n => n !== null)
    }
}
