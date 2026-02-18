pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> list: Mpris.players.values
    readonly property MprisPlayer active: manualActive ?? list.find(p => p.identity === "Spotify") ?? list[0] ?? null
    property MprisPlayer manualActive

    readonly property bool hasPlayer: active !== null && active !== undefined
    readonly property bool isPlaying: hasPlayer && active.isPlaying === true

    function togglePlaying() {
        var player = root.active;
        if (player !== null && player !== undefined && player.canTogglePlaying) {
            player.togglePlaying();
        }
    }

    function previous() {
        var player = root.active;
        if (player !== null && player !== undefined && player.canGoPrevious) {
            player.previous();
        }
    }

    function next() {
        var player = root.active;
        if (player !== null && player !== undefined && player.canGoNext) {
            player.next();
        }
    }

    function stop() {
        var player = root.active;
        if (player !== null && player !== undefined) {
            player.stop();
        }
    }
}
