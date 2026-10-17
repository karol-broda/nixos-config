pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import qs.theme
import qs.services

MouseArea {
    id: root

    required property var session
    required property ShellScreen screen

    readonly property int borderWidth: session.borderWidth
    readonly property int rounding: session.rounding
    readonly property real realRounding: onClient ? rounding : 0
    readonly property bool hideUI: session.hideChrome || (session.freeze && !frozenFrame.hasContent)
    readonly property bool canSelect: session.phase === "selecting" && (session.owner === null || session.owner === screen) && (!session.freeze || frozenFrame.hasContent)

    property bool onClient: false
    property var selectedWindows: []
    property var hoveredWindow: null
    property point dragStart: Qt.point(0, 0)
    property bool wasMultiSelectToggle: false
    property var _frozenClients: []
    property rect selection: Qt.rect(screen.width / 2 - 100, screen.height / 2 - 100, 200, 200)

    readonly property real sx: selection.x
    readonly property real sy: selection.y
    readonly property real ex: selection.x + selection.width
    readonly property real ey: selection.y + selection.height
    property real rsx: Math.min(sx, ex) * session.progress
    property real rsy: Math.min(sy, ey) * session.progress
    property real sw: Math.abs(sx - ex) * session.progress + screen.width * (1 - session.progress)
    property real sh: Math.abs(sy - ey) * session.progress + screen.height * (1 - session.progress)

    readonly property var liveClients: {
        const workspace = Hypr.monitorFor(root.screen)?.activeWorkspace
        const result = []
        for (const client of Hypr.toplevels?.values ?? []) {
            if (!workspace || client?.workspace?.id !== workspace.id) continue
            const ipc = client.lastIpcObject
            if (!ipc?.at || !ipc?.size) continue
            result.push({ address: client.address, ipc: {
                at: [ipc.at[0], ipc.at[1]], size: [ipc.size[0], ipc.size[1]],
                pinned: ipc.pinned ?? false, fullscreen: ipc.fullscreen ?? 0, floating: ipc.floating ?? false
            } })
        }
        return result.sort((a, b) => Number(b.ipc.pinned) - Number(a.ipc.pinned)
            || Number(b.ipc.fullscreen !== 0) - Number(a.ipc.fullscreen !== 0)
            || Number(b.ipc.floating) - Number(a.ipc.floating))
    }
    readonly property var clients: {
        if (!root.session.freeze) return root.liveClients
        const addresses = (Hypr.toplevels?.values ?? []).map(client => client?.address ?? "")
        return root._frozenClients.filter(client => addresses.includes(client.address))
    }

    function clientRect(client: var): rect {
        const ipc = client?.ipc
        if (!ipc?.at || !ipc?.size) return Qt.rect(0, 0, 0, 0)
        return Qt.rect(ipc.at[0] - root.screen.x, ipc.at[1] - root.screen.y, ipc.size[0], ipc.size[1])
    }

    function findClientByAddress(address: string): var {
        return root.clients.find(client => client.address === address) ?? null
    }

    function updateSelectionFromMultiple(): void {
        const rects = root.selectedWindows.map(address => root.clientRect(root.findClientByAddress(address)))
            .filter(rect => rect.width > 0 && rect.height > 0)
        if (rects.length === 0) return
        const x = Math.min(...rects.map(rect => rect.x))
        const y = Math.min(...rects.map(rect => rect.y))
        const ex = Math.max(...rects.map(rect => rect.x + rect.width))
        const ey = Math.max(...rects.map(rect => rect.y + rect.height))
        root.selection = Qt.rect(x, y, ex - x, ey - y)
        root.onClient = true
    }

    function checkClientRects(x: real, y: real): void {
        if (!root.canSelect) return
        root.hoveredWindow = root.clients.find(client => {
            const rect = root.clientRect(client)
            return x >= rect.x && y >= rect.y && x <= rect.x + rect.width && y <= rect.y + rect.height
        }) ?? null
        root.onClient = root.hoveredWindow !== null || root.selectedWindows.length > 0
        if (root.selectedWindows.length > 0) root.updateSelectionFromMultiple()
        else if (root.hoveredWindow !== null) root.selection = root.clientRect(root.hoveredWindow)
    }

    function toggleWindowSelection(client: var): void {
        if (!client) return
        const address = client.address
        root.selectedWindows = root.selectedWindows.includes(address)
            ? root.selectedWindows.filter(value => value !== address)
            : [...root.selectedWindows, address]
        if (root.selectedWindows.length > 0) root.updateSelectionFromMultiple()
        else root.checkClientRects(root.mouseX, root.mouseY)
    }

    onClientsChanged: {
        const hadSelection = root.selectedWindows.length > 0
        root.selectedWindows = root.selectedWindows.filter(address => root.findClientByAddress(address) !== null)
        if (root.selectedWindows.length > 0) {
            root.updateSelectionFromMultiple()
        } else if (!root.pressed) {
            if (hadSelection) root.selection = Qt.rect(root.screen.width / 2 - 100, root.screen.height / 2 - 100, 200, 200)
            root.checkClientRects(root.mouseX, root.mouseY)
        }
    }

    anchors.fill: parent
    opacity: session.progress
    hoverEnabled: true
    cursorShape: Qt.CrossCursor
    focus: true
    Keys.onEscapePressed: session.cancel()

    Component.onCompleted: {
        root._frozenClients = root.liveClients.slice()
        if (root.clients.length > 0) {
            root.selection = root.clientRect(root.clients[0])
            root.onClient = true
        }
    }

    onPressed: event => {
        if (!root.canSelect || !root.session.claim(root.screen)) {
            event.accepted = false
            return
        }
        root.dragStart = Qt.point(event.x, event.y)
        root.wasMultiSelectToggle = false
        root.checkClientRects(event.x, event.y)
        if ((event.modifiers & Qt.ShiftModifier) !== 0 && root.hoveredWindow !== null) {
            root.toggleWindowSelection(root.hoveredWindow)
            root.wasMultiSelectToggle = true
        } else {
            const hadSelection = root.selectedWindows.length > 0
            root.selectedWindows = []
            if (!hadSelection) {
                root.selection = root.hoveredWindow !== null
                    ? root.clientRect(root.hoveredWindow)
                    : Qt.rect(event.x, event.y, 0, 0)
            }
        }
    }

    onPositionChanged: event => {
        if (!root.canSelect) return
        if (root.pressed && !root.wasMultiSelectToggle) {
            root.onClient = false
            root.selection = Qt.rect(root.dragStart.x, root.dragStart.y, event.x - root.dragStart.x, event.y - root.dragStart.y)
        } else {
            root.checkClientRects(event.x, event.y)
        }
    }

    onReleased: {
        if (!root.canSelect) return
        if (root.wasMultiSelectToggle) {
            root.wasMultiSelectToggle = false
            return
        }
        root.session.capture(root.screen, Qt.rect(Math.min(root.sx, root.ex), Math.min(root.sy, root.ey), Math.abs(root.ex - root.sx), Math.abs(root.ey - root.sy)))
    }

    FrameAnimation {
        id: captureFrames
        running: root.session.phase === "settling" && root.session.owner === root.screen
        onTriggered: {
            if (currentFrame >= 3) root.session.framesReady(root.screen)
        }
    }

    ScreencopyView {
        id: frozenFrame
        anchors.fill: parent
        captureSource: root.session.freeze ? root.screen : null
        live: false
    }

    Rectangle {
        id: dimOverlay

        anchors.fill: parent
        color: Colors.withAlpha(Colors.crust, 0.6)
        visible: !root.hideUI

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: selectionMask
            maskEnabled: true
            maskInverted: true
            maskSpreadAtMin: 1
            maskThresholdMin: 0.5
        }
    }

    Item {
        id: selectionMask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            id: selectionRect

            radius: root.realRounding
            x: root.rsx
            y: root.rsy
            implicitWidth: root.sw
            implicitHeight: root.sh
        }
    }

    Item {
        id: selectionBorder

        visible: !root.hideUI
        x: selectionRect.x
        y: selectionRect.y
        width: selectionRect.implicitWidth
        height: selectionRect.implicitHeight

        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            color: "transparent"
            radius: root.realRounding > 0 ? root.realRounding + 3 : Spacing.radiusInner

            border.width: 3
            border.color: Colors.withAlpha(Colors.accent, 0.9)

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Colors.withAlpha(Colors.accent, 0.4)
                shadowBlur: 0.5
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 0
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            color: "transparent"
            radius: root.realRounding > 0 ? root.realRounding + 1 : Spacing.radiusNested

            border.width: 1
            border.color: Colors.withAlpha(Colors.textPrimary, 0.3)
        }

        Repeater {
            model: [
                { hx: -6, hy: -6 },
                { hx: selectionBorder.width + 6, hy: -6 },
                { hx: -6, hy: selectionBorder.height + 6 },
                { hx: selectionBorder.width + 6, hy: selectionBorder.height + 6 }
            ]

            Rectangle {
                required property var modelData

                x: modelData.hx - width / 2
                y: modelData.hy - height / 2
                width: 12
                height: 12
                radius: 3
                color: Colors.accent

                border.width: 2
                border.color: Colors.withAlpha(Colors.textPrimary, 0.9)

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: Colors.withAlpha(Colors.crust, 0.5)
                    shadowBlur: 0.3
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 1
                }
            }
        }
    }

    Repeater {
        model: root.selectedWindows

        Rectangle {
            id: selectedIndicator

            required property string modelData

            visible: !root.hideUI

            readonly property rect clientRect: root.clientRect(root.findClientByAddress(modelData))

            x: clientRect.x - 2
            y: clientRect.y - 2
            width: clientRect.width + 4
            height: clientRect.height + 4
            radius: root.rounding + 2
            color: "transparent"

            border.width: 2
            border.color: Colors.withAlpha(Colors.peach, 0.8)

            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 4
                anchors.rightMargin: 4
                width: 20
                height: 20
                radius: 10
                color: Colors.peach

                Text {
                    anchors.centerIn: parent
                    text: "✓"
                    color: Colors.crust
                    font.pixelSize: 12
                    font.weight: Typography.weightSemiBold
                }
            }
        }
    }

    Rectangle {
        id: dimensionBadge

        visible: !root.hideUI && root.sw > 60 && root.sh > 40
        x: selectionRect.x + (selectionRect.implicitWidth - width) / 2
        y: selectionRect.y - height - 12
        width: dimensionText.width + 20
        height: 28
        radius: Spacing.radiusFull

        color: Colors.withAlpha(Colors.bgElevated, 0.65)

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Colors.withAlpha(Colors.crust, 0.4)
            shadowBlur: 0.3
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 2
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: Colors.withAlpha(Colors.textPrimary, 0.08)
        }

        Text {
            id: dimensionText

            anchors.centerIn: parent
            text: Math.floor(root.sw) + " × " + Math.floor(root.sh)
            color: Colors.textPrimary
            font.family: Typography.monoTextFamily
            font.pixelSize: Typography.labelSize
            font.weight: Typography.monoTextWeight
            font.letterSpacing: Typography.labelSpacing
        }
    }

    Rectangle {
        id: helpBar

        visible: !root.hideUI
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 24
        width: helpContent.width + 32
        height: 40
        radius: Spacing.radiusFull

        color: Colors.withAlpha(Colors.bgElevated, 0.65)

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Colors.withAlpha(Colors.crust, 0.5)
            shadowBlur: 0.4
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: Colors.withAlpha(Colors.textPrimary, 0.08)
        }

        Row {
            id: helpContent

            anchors.centerIn: parent
            spacing: Spacing.spacingSm

            Text {
                text: "drag to select"
                color: Colors.textMuted
                font.family: Typography.labelFamily
                font.pixelSize: Typography.labelSize
                font.letterSpacing: Typography.labelSpacing
            }

            Text {
                text: "·"
                color: Colors.textDim
                font.family: Typography.displayFamily
                font.pixelSize: Typography.labelSize
            }

            Text {
                text: "shift+click"
                color: Colors.peach
                font.family: Typography.monoTextFamily
                font.pixelSize: Typography.labelSize
                font.weight: Typography.monoTextWeight
            }

            Text {
                text: "multi-select windows"
                color: Colors.textMuted
                font.family: Typography.labelFamily
                font.pixelSize: Typography.labelSize
                font.letterSpacing: Typography.labelSpacing
            }

            Text {
                text: "·"
                color: Colors.textDim
                font.family: Typography.displayFamily
                font.pixelSize: Typography.labelSize
            }

            Text {
                text: "esc"
                color: Colors.accent
                font.family: Typography.monoTextFamily
                font.pixelSize: Typography.labelSize
                font.weight: Typography.monoTextWeight
            }

            Text {
                text: "cancel"
                color: Colors.textMuted
                font.family: Typography.labelFamily
                font.pixelSize: Typography.labelSize
                font.letterSpacing: Typography.labelSpacing
            }
        }
    }

    Behavior on rsx {
        enabled: !root.pressed && root.session.phase === "selecting"

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on rsy {
        enabled: !root.pressed && root.session.phase === "selecting"

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on sw {
        enabled: !root.pressed && root.session.phase === "selecting"

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on sh {
        enabled: !root.pressed && root.session.phase === "selecting"

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }
}
