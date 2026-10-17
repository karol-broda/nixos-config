pragma Singleton

import QtQuick
import Quickshell
import qs.services
import qs.state

Singleton {
    id: root

    readonly property bool open: Shell.current?.panel === "launcher"

    property string text: ""
    property int selectedIndex: 0
    property bool _activatePending: false

    readonly property var results: Elephant.response.items
    readonly property bool fresh: Elephant.response.query === root.text

    function setText(value: string): void {
        if (value === root.text) return
        root.text = value
        root.selectedIndex = 0
        Elephant.query(value)
    }

    function select(index: int): void {
        root.selectedIndex = Math.max(0, Math.min(index, root.results.length - 1))
    }

    function selectNext(): void {
        root.select(root.selectedIndex + 1)
    }

    function selectPrev(): void {
        root.select(root.selectedIndex - 1)
    }

    function activate(index: int): void {
        root.selectedIndex = index
        if (root.fresh) root._activateNow()
        else root._activatePending = true
    }

    function activateSelected(): void {
        root.activate(root.selectedIndex)
    }

    function _activateNow(): void {
        if (!root.open) return
        root._activatePending = false
        const item = root.results[root.selectedIndex]
        if (item === undefined) return
        Elephant.activate(item)
        Shell.closePanel()
    }

    onFreshChanged: {
        if (!root.fresh) return
        root.select(root.selectedIndex)
        if (root._activatePending) Qt.callLater(root._activateNow)
    }

    onOpenChanged: {
        root._activatePending = false
        root.text = ""
        root.selectedIndex = 0
        if (root.open) Elephant.query("")
    }
}
