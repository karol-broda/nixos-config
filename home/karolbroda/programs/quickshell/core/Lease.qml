import QtQuick

QtObject {
    id: root

    required property var target
    property bool active: true

    property bool _held: false

    function _sync(): void {
        const want = root.active && root.target !== null
        if (want === root._held) return
        root._held = want
        root.target.users += want ? 1 : -1
    }

    onActiveChanged: _sync()
    Component.onCompleted: _sync()
    Component.onDestruction: {
        if (root._held) {
            root._held = false
            root.target.users -= 1
        }
    }
}
