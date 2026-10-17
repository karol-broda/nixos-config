pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> list: Mpris.players.values
    readonly property MprisPlayer active: list.find(p => p.identity === "Spotify") ?? list[0] ?? null
    readonly property bool hasPlayer: active !== null
    readonly property bool isPlaying: active?.isPlaying ?? false
    readonly property string title: active?.trackTitle ?? ""
    readonly property string artist: active?.trackArtist ?? ""
    readonly property string artUrl: active?.trackArtUrl ?? ""

    function togglePlaying(): void {
        if (root.active?.canTogglePlaying) root.active.togglePlaying()
    }

    function next(): void {
        if (root.active?.canGoNext) root.active.next()
    }

    function previous(): void {
        if (root.active?.canGoPrevious) root.active.previous()
    }
}
