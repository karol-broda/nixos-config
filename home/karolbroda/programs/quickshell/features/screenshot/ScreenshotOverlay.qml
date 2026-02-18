pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

Scope {
    id: root

    LazyLoader {
        id: loader

        property bool freeze: false
        property bool closing: false

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
                WlrLayershell.keyboardFocus: loader.closing ? WlrKeyboardFocus.None : WlrKeyboardFocus.Exclusive

                mask: loader.closing ? emptyRegion : null

                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true

                Region {
                    id: emptyRegion
                }

                ScreenshotPicker {
                    loader: loader
                    screen: win.modelData
                }
            }
        }
    }

    GlobalShortcut {
        name: "screenshot"
        description: "open screenshot tool"

        onPressed: {
            loader.freeze = false;
            loader.closing = false;
            loader.activeAsync = true;
        }
    }

    GlobalShortcut {
        name: "screenshotFreeze"
        description: "open screenshot tool (freeze mode)"

        onPressed: {
            loader.freeze = true;
            loader.closing = false;
            loader.activeAsync = true;
        }
    }
}
