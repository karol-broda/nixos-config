pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs.core
import qs.services
import qs.theme

Scope {
    id: root

    readonly property string phase: flow.state
    readonly property bool freeze: _session.freeze
    readonly property ShellScreen owner: _session.owner
    readonly property bool hideChrome: flow.is("settling", "capturing") || (flow.is("closing") && _session.file !== "")
    readonly property int borderWidth: _decoration.border
    readonly property int rounding: _decoration.rounding

    property var _session: ({ freeze: false, owner: null, geometry: "", file: "", saved: false, tag: "" })
    property var _decoration: ({ border: 2, rounding: 12 })
    property real progress: 1

    function open(frozen: bool): void {
        if (!flow.is("idle")) return
        root._session = { freeze: frozen, owner: null, geometry: "", file: "", saved: false, tag: Date.now() + "-" + Math.random().toString(36).slice(2) }
        root.progress = 1
        flow.go("selecting")
        borderJob.run(["hyprctl", "-j", "getoption", "general:border_size"], root._session.tag)
        roundingJob.run(["hyprctl", "-j", "getoption", "decoration:rounding"], root._session.tag)
    }

    function claim(screen: ShellScreen): bool {
        if (!flow.is("selecting") || (root.owner !== null && root.owner !== screen)) return false
        if (root.owner === null) root._session = Object.assign({}, root._session, { owner: screen })
        return true
    }

    function capture(screen: ShellScreen, rect: rect): void {
        if (!root.claim(screen)) return
        const x = Math.ceil(Math.max(0, rect.x))
        const y = Math.ceil(Math.max(0, rect.y))
        const w = Math.floor(Math.min(screen.width, rect.x + rect.width)) - x
        const h = Math.floor(Math.min(screen.height, rect.y + rect.height)) - y
        if (w <= 0 || h <= 0) return
        const runtime = Quickshell.env("XDG_RUNTIME_DIR") ?? ""
        if (runtime === "") {
            console.warn("[screenshot] XDG_RUNTIME_DIR is missing")
            return
        }
        root._session = Object.assign({}, root._session, {
            geometry: (screen.x + x) + "," + (screen.y + y) + " " + w + "x" + h,
            file: runtime + "/quickshell-screenshot-" + root._session.tag + ".png"
        })
        flow.go("settling")
    }

    function framesReady(screen: ShellScreen): void {
        if (!flow.is("settling") || root.owner !== screen) return
        flow.go("capturing")
        captureJob.run(["sh", "-c", 'umask 077; exec grim -l 0 -g "$1" "$2"', "quickshell-screenshot", root._session.geometry, root._session.file], root._session.tag)
    }

    function cancel(): void {
        if (flow.is("idle", "closing")) return
        captureJob.cancel()
        flow.go("closing")
    }

    function _setDecoration(tag: var, output: string, exitCode: int, key: string): void {
        if (tag !== root._session.tag || exitCode !== 0) return
        try {
            const value = JSON.parse(output)?.int
            if (typeof value === "number" && isFinite(value) && value >= 0) {
                const change = {}
                change[key] = value
                root._decoration = Object.assign({}, root._decoration, change)
            }
        } catch (e) {
            console.warn("[screenshot] invalid hyprctl option output")
        }
    }

    function _launchSaved(): void {
        if (!flow.is("idle") || loader.item !== null || !root._session.saved) return
        const file = root._session.file
        root._session = Object.assign({}, root._session, { saved: false })
        Env.launch(["swappy", "-f", file])
    }

    Fsm {
        id: flow
        initial: "idle"
        transitions: ({
            idle: ["selecting"],
            selecting: ["settling", "closing"],
            settling: ["capturing", "closing"],
            capturing: ["closing"],
            closing: ["idle"]
        })
        onEntered: state => {
            if (state === "closing") closeMotion.start()
        }
    }

    NumberAnimation {
        id: closeMotion
        target: root
        property: "progress"
        to: 0
        duration: Motion.durationNormal
        easing.type: Easing.OutQuart
        onFinished: {
            flow.go("idle")
            Qt.callLater(root._launchSaved)
        }
    }

    Job {
        id: captureJob
        environment: Env.withProfilePath
        timeout: 15000
        onFinished: (tag, output, exitCode) => {
            if (tag !== root._session.tag || !flow.is("capturing")) return
            root._session = Object.assign({}, root._session, { saved: exitCode === 0 })
            if (exitCode !== 0) console.warn("[screenshot] grim failed", exitCode)
            flow.go("closing")
        }
    }

    Job {
        id: borderJob
        environment: Env.withProfilePath
        timeout: 3000
        onFinished: (tag, output, exitCode) => root._setDecoration(tag, output, exitCode, "border")
    }

    Job {
        id: roundingJob
        environment: Env.withProfilePath
        timeout: 3000
        onFinished: (tag, output, exitCode) => root._setDecoration(tag, output, exitCode, "rounding")
    }

    LazyLoader {
        id: loader
        active: !flow.is("idle")
        onItemChanged: root._launchSaved()

        Variants {
            model: Quickshell.screens

            PanelWindow {
                id: win
                required property ShellScreen modelData

                screen: modelData
                color: "transparent"
                WlrLayershell.namespace: "quickshell-screenshot"
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: root.phase === "closing" ? WlrKeyboardFocus.None : WlrKeyboardFocus.Exclusive
                mask: root.phase === "selecting" ? null : emptyRegion
                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true

                Region { id: emptyRegion }

                ScreenshotPicker {
                    session: root
                    screen: win.modelData
                }

                onScreenChanged: {
                    if (screen === null) root.cancel()
                }
            }
        }
    }

    GlobalShortcut {
        name: "screenshot"
        description: "open screenshot tool"
        onPressed: root.open(false)
    }

    GlobalShortcut {
        name: "screenshotFreeze"
        description: "open screenshot tool (freeze mode)"
        onPressed: root.open(true)
    }
}
