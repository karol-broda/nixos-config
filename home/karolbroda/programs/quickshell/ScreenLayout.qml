import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.theme
import qs.services
import qs.features.bar
import qs.features.overlay

Scope {
    id: root

    required property ShellScreen screen

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
            anchors.fill: parent
            screen: root.screen
        }
    }

    ScreenOverlay {
        modelData: root.screen
    }
}
