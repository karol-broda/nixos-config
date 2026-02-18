pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    function openPanel(name) {
        return { type: "panel.open", payload: { name: name } }
    }

    function closePanel() {
        return { type: "panel.close", payload: {} }
    }

    function togglePanel(name) {
        return { type: "panel.toggle", payload: { name: name } }
    }

    function playPause() {
        return { type: "media.playPause", payload: {} }
    }

    function nextTrack() {
        return { type: "media.next", payload: {} }
    }

    function prevTrack() {
        return { type: "media.prev", payload: {} }
    }

    function lock() {
        return { type: "system.lock", payload: {} }
    }

    function logout() {
        return { type: "system.logout", payload: {} }
    }

    function suspend() {
        return { type: "system.suspend", payload: {} }
    }

    function reboot() {
        return { type: "system.reboot", payload: {} }
    }

    function shutdown() {
        return { type: "system.shutdown", payload: {} }
    }

    function setVolume(value) {
        return { type: "audio.setVolume", payload: { value: value } }
    }

    function toggleMute() {
        return { type: "audio.toggleMute", payload: {} }
    }

    function setBrightness(value) {
        return { type: "brightness.set", payload: { value: value } }
    }

    function toggleWifi() {
        return { type: "network.toggleWifi", payload: {} }
    }

    function switchWorkspace(id) {
        return { type: "workspace.switch", payload: { id: id } }
    }

    function launcherSearch(query) {
        return { type: "launcher.search", payload: { query: query } }
    }

    function launcherActivate(item) {
        return { type: "launcher.activate", payload: { item: item } }
    }

    function launcherSelectNext() {
        return { type: "launcher.selectNext", payload: {} }
    }

    function launcherSelectPrev() {
        return { type: "launcher.selectPrev", payload: {} }
    }

    function dismissNotification(id) {
        return { type: "notification.dismiss", payload: { id: id } }
    }

    function clearAllNotifications() {
        return { type: "notification.clearAll", payload: {} }
    }
}
