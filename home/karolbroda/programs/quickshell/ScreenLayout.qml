import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.theme
import qs.core
import qs.services
import qs.features.bar
import qs.features.frame
import qs.features.osd
import qs.features.toasts

Item {
    id: root

    required property var screen

    readonly property int monitorId: {
        const mon = Hyprland.monitorFor(root.screen)
        if (mon === null || mon === undefined) return -1
        return mon.id
    }

    readonly property bool panelActiveHere: Dispatcher.isPanelOnMonitor(root.monitorId)

    // combined check: panel is active AND this screen has a valid hyprland mapping.
    // use this for content that must only appear on a single, known monitor.
    readonly property bool isActiveScreen: monitorId >= 0 && panelActiveHere

    PanelWindow {
        id: barWindow

        screen: root.screen
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bar"

        anchors {
            top: true
            left: true
            right: true
        }

        exclusiveZone: Spacing.barHeight + Spacing.frameWidth - 5
        implicitHeight: Spacing.barHeight

        IdleInhibitor {
            enabled: Players.isPlaying
            window: barWindow
        }

        Bar {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Spacing.barHeight
            screen: root.screen
        }
    }

    PanelWindow {
        screen: root.screen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Bottom
        WlrLayershell.namespace: "quickshell-frame"

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        ScreenFrame {
            anchors.fill: parent
            screen: root.screen
        }
    }

    PanelWindow {
        screen: root.screen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-osd"

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        mask: Region {}

        OsdPopup {
            anchors.fill: parent
            screen: root.screen
        }
    }

    PanelWindow {
        screen: root.screen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-toasts"

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        ToastContainer {
            id: toastContainer
            anchors.fill: parent
            screen: root.screen
        }

        mask: Region {
            item: toastContainer.inputMaskItem
        }
    }

    PanelWindow {
        id: panelsWindow

        screen: root.screen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-panels"
        WlrLayershell.keyboardFocus: root.panelActiveHere ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        mask: Region {
            item: root.panelActiveHere ? fullMaskItem : null
        }

        Item {
            id: fullMaskItem
            anchors.fill: parent
            visible: false

            Rectangle {
                anchors.fill: parent
                color: "black"
            }
        }

        PanelsOverlay {
            anchors.fill: parent
            screenActive: root.panelActiveHere
            isActiveScreen: root.isActiveScreen
            panelWindow: panelsWindow
        }
    }
}
