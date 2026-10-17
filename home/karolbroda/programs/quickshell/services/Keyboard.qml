pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.core

Singleton {
    id: root

    readonly property string layout: layoutFull.slice(0, 2).toLowerCase()
    readonly property string layoutFull: _keyboard.layout

    property var _keyboard: ({ name: "", layout: "" })
    property var _events: ({})

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name !== "activelayout") return
            const comma = event.data.indexOf(",")
            if (comma < 1) return
            const name = event.data.slice(0, comma)
            const layout = event.data.slice(comma + 1)
            root._events = Object.assign({}, root._events, { [name]: layout })
            if (name === root._keyboard.name) root._keyboard = { name: name, layout: layout }
        }
    }

    Job {
        id: snapshot
        environment: Env.withProfilePath
        timeout: 5000
        onFinished: (tag, output, exitCode) => {
            if (exitCode !== 0) return
            try {
                const keyboards = JSON.parse(output)?.keyboards
                if (!Array.isArray(keyboards)) return
                const main = keyboards.find(k => k?.main === true)
                if (!main?.name) return
                root._keyboard = { name: main.name, layout: root._events[main.name] ?? main.active_keymap ?? "" }
            } catch (e) {
                console.warn("[Keyboard] invalid devices response")
            }
        }
    }

    Component.onCompleted: snapshot.run(["hyprctl", "-j", "devices"], null)
}
