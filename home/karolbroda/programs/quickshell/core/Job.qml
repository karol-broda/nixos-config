import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property var environment: ({})
    property int timeout: 0

    readonly property bool busy: proc.running || root._queued !== null

    signal finished(var tag, string output, int exitCode)

    property var _queued: null
    property var _active: null

    function run(command: var, tag: var): void {
        root._queued = { command: command, tag: tag }
        if (!proc.running && root._active === null) root._startQueued()
    }

    function poll(command: var, tag: var): void {
        if (!root.busy) root.run(command, tag)
    }

    function cancel(): void {
        root._queued = null
        if (root._active !== null) root._active.cancelled = true
    }

    function _startQueued(): void {
        const req = root._queued
        if (req === null) return
        root._queued = null
        root._active = { tag: req.tag, cancelled: false }
        proc.command = req.command
        proc.running = true
        if (root.timeout > 0) watchdog.restart()
    }

    function _complete(exitCode: int): void {
        const req = root._active
        if (req === null) return
        root._active = null
        watchdog.stop()

        if (!req.cancelled && root._queued === null) root.finished(req.tag, collector.text, exitCode)
        if (root._queued !== null) Qt.callLater(root._startQueued)
    }

    Process {
        id: proc

        environment: root.environment
        stdout: StdioCollector {
            id: collector
        }

        onExited: exitCode => root._complete(exitCode)

        onRunningChanged: {
            if (!running && root._active !== null) root._complete(-1)
        }
    }

    Timer {
        id: watchdog
        interval: root.timeout
        onTriggered: proc.signal(9)
    }
}
