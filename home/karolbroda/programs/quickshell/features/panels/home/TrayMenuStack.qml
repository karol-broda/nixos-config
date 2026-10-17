import QtQuick
import qs.services

QtObject {
    id: root

    property list<QtObject> levels: []

    readonly property Component _levelComponent: Component {
        QtObject {
            required property var entry
            required property real x
            required property real y
            required property int depth
            property bool open: true
        }
    }

    function openAt(depth: int, entry: var, x: real, y: real): void {
        const top = root.levels.find(l => l.open && l.depth === depth)
        if (top?.entry === entry) return
        root.closeFrom(depth)
        root.levels.push(root._levelComponent.createObject(root, { entry: entry, x: x, y: y, depth: depth }))
    }

    function closeFrom(depth: int): void {
        for (const level of root.levels) {
            if (level.depth >= depth) level.open = false
        }
    }

    function forget(level: QtObject): void {
        const idx = root.levels.indexOf(level)
        if (idx < 0) return
        root.levels.splice(idx, 1)
        level.destroy()
    }

    readonly property Connections _trayWatch: Connections {
        target: Tray

        function onActiveMenuItemChanged(): void {
            root.closeFrom(0)
        }
    }
}
