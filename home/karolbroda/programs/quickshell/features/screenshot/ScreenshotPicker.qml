pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects

import qs.theme
import qs.services as Services

MouseArea {
    id: root

    required property LazyLoader loader
    required property ShellScreen screen

    property int borderWidth: 2
    property int rounding: 12

    property bool onClient: false

    property var selectedWindows: []

    property var hoveredWindow: null

    property real realBorderWidth: onClient ? borderWidth : 2
    property real realRounding: onClient ? rounding : 0

    property real ssx: 0
    property real ssy: 0

    property real sx: 0
    property real sy: 0
    property real ex: screen.width
    property real ey: screen.height

    property real rsx: Math.min(sx, ex)
    property real rsy: Math.min(sy, ey)
    property real sw: Math.abs(sx - ex)
    property real sh: Math.abs(sy - ey)

    property list<var> clients: {
        var wsId = Services.Hyprland.activeWsId;

        var result = [];
        var toplevels = Services.Hyprland.toplevels;
        if (toplevels === null || toplevels === undefined) {
            return result;
        }

        var values = toplevels.values;
        if (values === null || values === undefined) {
            return result;
        }

        for (var i = 0; i < values.length; i++) {
            var c = values[i];
            if (c !== null && c !== undefined) {
                var cws = c.workspace;
                if (cws !== null && cws !== undefined && cws.id === wsId) {
                    result.push(c);
                }
            }
        }

        result.sort(function(a, b) {
            var ac = a.lastIpcObject;
            var bc = b.lastIpcObject;
            if (ac === null || ac === undefined) return 1;
            if (bc === null || bc === undefined) return -1;

            var pinnedDiff = (bc.pinned ? 1 : 0) - (ac.pinned ? 1 : 0);
            if (pinnedDiff !== 0) return pinnedDiff;

            var fullscreenDiff = ((bc.fullscreen !== 0) ? 1 : 0) - ((ac.fullscreen !== 0) ? 1 : 0);
            if (fullscreenDiff !== 0) return fullscreenDiff;

            var floatingDiff = (bc.floating ? 1 : 0) - (ac.floating ? 1 : 0);
            return floatingDiff;
        });

        return result;
    }

    function checkClientRects(x: real, y: real): void {
        hoveredWindow = null;

        for (var i = 0; i < clients.length; i++) {
            var client = clients[i];
            if (client === null || client === undefined) continue;

            var ipc = client.lastIpcObject;
            if (ipc === null || ipc === undefined) continue;

            var at = ipc.at;
            var size = ipc.size;
            if (at === null || at === undefined || size === null || size === undefined) continue;

            var cx = at[0] - screen.x;
            var cy = at[1] - screen.y;
            var cw = size[0];
            var ch = size[1];

            if (cx <= x && cy <= y && cx + cw >= x && cy + ch >= y) {
                hoveredWindow = client;
                onClient = true;

                if (selectedWindows.length > 0) {
                    updateSelectionFromMultiple();
                } else {
                    sx = cx;
                    sy = cy;
                    ex = cx + cw;
                    ey = cy + ch;
                }
                return;
            }
        }
        onClient = false;
        hoveredWindow = null;

        if (selectedWindows.length > 0) {
            updateSelectionFromMultiple();
            onClient = true;
        }
    }

    function updateSelectionFromMultiple(): void {
        if (selectedWindows.length === 0) return;

        var minX = 999999;
        var minY = 999999;
        var maxX = -999999;
        var maxY = -999999;

        for (var i = 0; i < selectedWindows.length; i++) {
            var addr = selectedWindows[i];
            var client = findClientByAddress(addr);
            if (client === null || client === undefined) continue;

            var ipc = client.lastIpcObject;
            if (ipc === null || ipc === undefined) continue;

            var at = ipc.at;
            var size = ipc.size;
            if (at === null || at === undefined || size === null || size === undefined) continue;

            var cx = at[0] - screen.x;
            var cy = at[1] - screen.y;
            var cw = size[0];
            var ch = size[1];

            if (cx < minX) minX = cx;
            if (cy < minY) minY = cy;
            if (cx + cw > maxX) maxX = cx + cw;
            if (cy + ch > maxY) maxY = cy + ch;
        }

        if (minX < 999999) {
            sx = minX;
            sy = minY;
            ex = maxX;
            ey = maxY;
        }
    }

    function findClientByAddress(addr: string): var {
        for (var i = 0; i < clients.length; i++) {
            var client = clients[i];
            if (client !== null && client !== undefined && client.address === addr) {
                return client;
            }
        }
        return null;
    }

    function isWindowSelected(addr: string): bool {
        for (var i = 0; i < selectedWindows.length; i++) {
            if (selectedWindows[i] === addr) return true;
        }
        return false;
    }

    function toggleWindowSelection(client: var): void {
        if (client === null || client === undefined) return;

        var addr = client.address;
        var newSelection = [];
        var found = false;

        for (var i = 0; i < selectedWindows.length; i++) {
            if (selectedWindows[i] === addr) {
                found = true;
            } else {
                newSelection.push(selectedWindows[i]);
            }
        }

        if (!found) {
            newSelection.push(addr);
        }

        selectedWindows = newSelection;
        updateSelectionFromMultiple();
    }

    anchors.fill: parent
    opacity: 0
    hoverEnabled: true
    cursorShape: Qt.CrossCursor

    Component.onCompleted: {
        if (loader.freeze) {
            clients = clients;
        }

        opacity = 1;

        if (clients.length > 0) {
            var c = clients[0];
            if (c !== null && c !== undefined) {
                var ipc = c.lastIpcObject;
                if (ipc !== null && ipc !== undefined) {
                    var at = ipc.at;
                    var size = ipc.size;
                    if (at !== null && at !== undefined && size !== null && size !== undefined) {
                        var cx = at[0] - screen.x;
                        var cy = at[1] - screen.y;
                        onClient = true;
                        sx = cx;
                        sy = cy;
                        ex = cx + size[0];
                        ey = cy + size[1];
                        return;
                    }
                }
            }
        }

        sx = screen.width / 2 - 100;
        sy = screen.height / 2 - 100;
        ex = screen.width / 2 + 100;
        ey = screen.height / 2 + 100;
    }

    property bool wasMultiSelectToggle: false

    onPressed: function(event) {
        ssx = event.x;
        ssy = event.y;
        wasMultiSelectToggle = false;

        if ((event.modifiers & Qt.ShiftModifier) !== 0 && hoveredWindow !== null && hoveredWindow !== undefined) {
            toggleWindowSelection(hoveredWindow);
            wasMultiSelectToggle = true;
        } else if (selectedWindows.length > 0) {
            selectedWindows = [];
        }
    }

    property int captureX: 0
    property int captureY: 0
    property int captureW: 0
    property int captureH: 0

    onReleased: {
        if (closeAnim.running || captureAnim.running) {
            return;
        }

        if (wasMultiSelectToggle) {
            wasMultiSelectToggle = false;
            return;
        }

        captureX = screen.x + Math.ceil(rsx);
        captureY = screen.y + Math.ceil(rsy);
        captureW = Math.floor(sw);
        captureH = Math.floor(sh);

        captureAnim.start();
    }

    property bool hideUI: false

    SequentialAnimation {
        id: captureAnim

        PropertyAction {
            target: root
            property: "hideUI"
            value: true
        }

        PropertyAction {
            target: root.loader
            property: "closing"
            value: true
        }

        PauseAnimation {
            duration: 16
        }

        ScriptAction {
            script: {
                var cmd = "grim -l 0 -g '" + root.captureX + "," + root.captureY + " " + root.captureW + "x" + root.captureH + "' - | swappy -f -";
                Quickshell.execDetached(["sh", "-c", cmd]);
            }
        }

        PropertyAction {
            target: root.loader
            property: "activeAsync"
            value: false
        }
    }

    onPositionChanged: function(event) {
        var x = event.x;
        var y = event.y;

        if (pressed) {
            onClient = false;
            sx = ssx;
            sy = ssy;
            ex = x;
            ey = y;
        } else {
            checkClientRects(x, y);
        }
    }

    focus: true
    Keys.onEscapePressed: closeAnim.start()

    SequentialAnimation {
        id: closeAnim

        PropertyAction {
            target: root.loader
            property: "closing"
            value: true
        }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: Motion.durationNormal
                easing.type: Easing.OutQuart
            }

            NumberAnimation {
                target: root
                property: "rsx"
                to: 0
                duration: Motion.durationNormal
                easing.type: Easing.OutQuart
            }

            NumberAnimation {
                target: root
                property: "rsy"
                to: 0
                duration: Motion.durationNormal
                easing.type: Easing.OutQuart
            }

            NumberAnimation {
                target: root
                property: "sw"
                to: root.screen.width
                duration: Motion.durationNormal
                easing.type: Easing.OutQuart
            }

            NumberAnimation {
                target: root
                property: "sh"
                to: root.screen.height
                duration: Motion.durationNormal
                easing.type: Easing.OutQuart
            }
        }

        PropertyAction {
            target: root.loader
            property: "activeAsync"
            value: false
        }
    }

    Connections {
        target: Services.Hyprland

        function onActiveWsIdChanged(): void {
            root.checkClientRects(root.mouseX, root.mouseY);
        }
    }

    Process {
        running: true
        command: ["hyprctl", "-j", "getoption", "general:border_size"]
        stdout: StdioCollector {
            onStreamFinished: {
                var parsed = JSON.parse(text);
                if (parsed !== null && parsed !== undefined && parsed.int !== null && parsed.int !== undefined) {
                    root.borderWidth = parsed.int;
                }
            }
        }
    }

    Process {
        running: true
        command: ["hyprctl", "-j", "getoption", "decoration:rounding"]
        stdout: StdioCollector {
            onStreamFinished: {
                var parsed = JSON.parse(text);
                if (parsed !== null && parsed !== undefined && parsed.int !== null && parsed.int !== undefined) {
                    root.rounding = parsed.int;
                }
            }
        }
    }

    Loader {
        anchors.fill: parent
        active: root.loader.freeze
        asynchronous: true

        sourceComponent: ScreencopyView {
            captureSource: root.screen
        }
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
            radius: root.realRounding > 0 ? root.realRounding + 3 : Spacing.radiusSm

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
            radius: root.realRounding > 0 ? root.realRounding + 1 : Spacing.radiusXs

            border.width: 1
            border.color: Colors.withAlpha(Colors.textPrimary, 0.3)
        }

        Repeater {
            model: [
                { hx: -6, hy: -6 },
                { hx: parent.width + 6, hy: -6 },
                { hx: -6, hy: parent.height + 6 },
                { hx: parent.width + 6, hy: parent.height + 6 }
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

            property var client: root.findClientByAddress(modelData)
            property var ipc: client !== null && client !== undefined ? client.lastIpcObject : null
            property real wx: ipc !== null && ipc !== undefined && ipc.at !== null && ipc.at !== undefined ? ipc.at[0] - root.screen.x : 0
            property real wy: ipc !== null && ipc !== undefined && ipc.at !== null && ipc.at !== undefined ? ipc.at[1] - root.screen.y : 0
            property real ww: ipc !== null && ipc !== undefined && ipc.size !== null && ipc.size !== undefined ? ipc.size[0] : 0
            property real wh: ipc !== null && ipc !== undefined && ipc.size !== null && ipc.size !== undefined ? ipc.size[1] : 0

            x: wx - 2
            y: wy - 2
            width: ww + 4
            height: wh + 4
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
        radius: Spacing.radiusMd

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
        radius: Spacing.radiusLg

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

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.durationNormal
            easing.type: Easing.OutQuart
        }
    }

    Behavior on rsx {
        enabled: !root.pressed

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on rsy {
        enabled: !root.pressed

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on sw {
        enabled: !root.pressed

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on sh {
        enabled: !root.pressed

        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.OutQuart
        }
    }
}
