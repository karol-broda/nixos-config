pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
    id: root

    property string activePanel: ""
    // -1 means no panel is open
    property int activePanelMonitorId: -1

    signal actionDispatched(var action)
    signal lockRequested()

    function dispatch(action) {
        if (action === null || action === undefined) {
            return
        }

        const actionType = action.type
        const payload = action.payload || {}

        switch (actionType) {
            case "panel.open":
                root.activePanelMonitorId = _focusedMonitorId()
                root.activePanel = payload.name || ""
                break

            case "panel.close":
                root.activePanelMonitorId = -1
                root.activePanel = ""
                break

            case "panel.toggle":
                const targetPanel = payload.name || ""
                if (root.activePanel === targetPanel) {
                    root.activePanelMonitorId = -1
                    root.activePanel = ""
                } else {
                    root.activePanelMonitorId = _focusedMonitorId()
                    root.activePanel = targetPanel
                }
                break

            case "media.playPause":
                if (Players.active !== null && Players.active !== undefined) {
                    Players.active.togglePlaying()
                }
                break

            case "media.next":
                if (Players.active !== null && Players.active !== undefined) {
                    Players.active.next()
                }
                break

            case "media.prev":
                if (Players.active !== null && Players.active !== undefined) {
                    Players.active.previous()
                }
                break

            case "system.lock":
                root.lockRequested()
                break

            case "system.logout":
                Power.logout()
                break

            case "system.suspend":
                Power.suspend()
                break

            case "system.reboot":
                Power.reboot()
                break

            case "system.shutdown":
                Power.shutdown()
                break

            case "audio.setVolume":
                const vol = payload.value
                if (vol !== null && vol !== undefined) {
                    Audio.setVolume(vol)
                }
                break

            case "audio.toggleMute":
                Audio.toggleMute()
                break

            case "brightness.set":
                const bright = payload.value
                if (bright !== null && bright !== undefined) {
                    Brightness.setBrightness(bright)
                }
                break

            case "network.toggleWifi":
                Network.toggleWifi()
                break

            case "workspace.switch":
                const wsId = payload.id
                if (wsId !== null && wsId !== undefined) {
                    Hyprland.dispatch("workspace " + wsId)
                }
                break

            case "notification.dismiss":
                const notifId = payload.id
                if (notifId !== null && notifId !== undefined) {
                    Notifs.dismissById(notifId)
                }
                break

            case "notification.clearAll":
                Notifs.clearAll()
                break
        }

        root.actionDispatched(action)
    }

    function _focusedMonitorId(): int {
        const mon = Hyprland.focusedMonitor
        if (mon === null || mon === undefined) return -1
        return mon.id
    }

    function isPanelOnMonitor(monitorId: int): bool {
        if (root.activePanel === "") return false
        if (root.activePanelMonitorId < 0) return true
        return root.activePanelMonitorId === monitorId
    }

    function handleEscape() {
        if (Tray.activeMenuHandle !== null) {
            Tray.closeMenu()
            return true
        }
        if (root.activePanel !== "") {
            root.dispatch(Actions.closePanel())
            return true
        }
        return false
    }
}
