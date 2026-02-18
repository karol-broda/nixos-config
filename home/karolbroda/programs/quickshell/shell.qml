import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.theme
import qs.core
import qs.services
import qs.features.bar
import qs.features.panels.home
import qs.features.panels.dashboard
import qs.features.panels.launcher
import qs.features.panels.notifications
import qs.features.frame
import qs.features.osd
import qs.features.toasts
import qs.features.lockscreen
import qs.features.screenshot

ShellRoot {
    id: root

    Component.onCompleted: {
        console.log("Shell loaded")
    }

    GlobalShortcut {
        name: "launcher"
        description: "Open application launcher"

        onPressed: {
            Dispatcher.dispatch(Actions.togglePanel("launcher"))
        }
    }

    GlobalShortcut {
        name: "lock"
        description: "Lock the session"

        onPressed: {
            lock.locked = true
        }
    }

    Connections {
        target: Dispatcher

        function onLockRequested() {
            lock.locked = true
        }
    }

    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false
            lockContext.clearPassword()
        }
    }

    WlSessionLock {
        id: lock

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    ScreenshotOverlay {}

    Variants {
        model: Quickshell.screens

        delegate: Item {
            id: screenRoot

            required property var modelData
            property var screen: modelData

            readonly property int monitorId: {
                const mon = Hyprland.monitorFor(screenRoot.screen)
                if (mon === null || mon === undefined) return -1
                return mon.id
            }

            readonly property bool panelActiveHere: Dispatcher.isPanelOnMonitor(screenRoot.monitorId)

            PanelWindow {
                id: barWindow

                screen: screenRoot.screen
                color: "transparent"
                exclusionMode: ExclusionMode.Normal
                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.namespace: "quickshell-bar"

                anchors {
                    top: true
                    left: true
                    right: true
                }

                // explicit height for exclusive zone to work
                exclusiveZone: Spacing.barHeight + Spacing.frameWidth

                Bar {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: Spacing.barHeight
                    screen: screenRoot.screen
                }
            }

            PanelWindow {
                id: frameWindow

                screen: screenRoot.screen
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
                    screen: screenRoot.screen
                }
            }

            PanelWindow {
                id: osdWindow

                screen: screenRoot.screen
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
                    screen: screenRoot.screen
                }
            }

            PanelWindow {
                id: toastsWindow

                screen: screenRoot.screen
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
                    screen: screenRoot.screen
                }

                mask: Region {
                    item: toastContainer.inputMaskItem
                }
            }

            PanelWindow {
                id: panelsWindow

                screen: screenRoot.screen
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell-panels"
                WlrLayershell.keyboardFocus: screenRoot.panelActiveHere ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                mask: Region {
                    item: screenRoot.panelActiveHere ? fullMaskItem : null
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

                HyprlandFocusGrab {
                    id: focusGrab
                    active: screenRoot.panelActiveHere
                    windows: [panelsWindow]
                    onCleared: {
                        Dispatcher.dispatch(Actions.closePanel())
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    visible: screenRoot.panelActiveHere
                    onClicked: {
                        Dispatcher.dispatch(Actions.closePanel())
                    }
                }

                // unified outline drawn behind all panel content
                PanelOutline {
                    id: panelOutline

                    property var _subMenuRects: {
                        var result = []
                        var count = traySubMenuRepeater.count
                        for (var i = 0; i < count; i++) {
                            var item = traySubMenuRepeater.itemAt(i)
                            if (item !== null && item !== undefined && item.width > 0 && item.height > 0) {
                                result.push(item.panelRect)
                            }
                        }
                        return result
                    }

                    panels: [
                        homePanel.panelRect,
                        trayFlyout.panelRect,
                        dashboardPanel.panelRect,
                        launcherPanel.panelRect,
                        notifPanel.panelRect
                    ].concat(_subMenuRects)
                    frameTop: Spacing.barHeight + Spacing.frameWidth
                    frameLeft: Spacing.frameWidth
                    frameRight: panelsWindow.width - Spacing.frameWidth
                    frameBottom: panelsWindow.height - Spacing.frameWidth
                    gapThreshold: 0
                }

                HomePanel {
                    id: homePanel
                    screenActive: screenRoot.panelActiveHere
                    anchors.left: parent.left
                    anchors.leftMargin: Spacing.frameWidth
                    anchors.top: parent.top
                    anchors.topMargin: Spacing.barHeight + Spacing.frameWidth
                }

                TrayFlyout {
                    id: trayFlyout
                    panelOpen: homePanel.isOpen
                    x: homePanel.x + homePanel.width
                    anchors.top: parent.top
                    anchors.topMargin: Spacing.barHeight + Spacing.frameWidth
                }

                Repeater {
                    id: traySubMenuRepeater
                    model: Tray.subMenuStack

                    delegate: TraySubMenu {
                        required property var modelData
                        required property int index

                        x: modelData.x
                        y: modelData.y
                        menuEntry: modelData.entry
                        level: index
                    }
                }

                DashboardPanel {
                    id: dashboardPanel
                    screenActive: screenRoot.panelActiveHere
                    anchors.right: parent.right
                    anchors.rightMargin: Spacing.frameWidth
                    anchors.top: parent.top
                    anchors.topMargin: Spacing.barHeight + Spacing.frameWidth
                }

                LauncherPanel {
                    id: launcherPanel
                    screenActive: screenRoot.panelActiveHere
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: Spacing.barHeight + Spacing.frameWidth
                }

                NotifPanel {
                    id: notifPanel
                    screenActive: screenRoot.panelActiveHere
                    anchors.right: parent.right
                    anchors.rightMargin: Spacing.frameWidth
                    anchors.top: parent.top
                    anchors.topMargin: Spacing.barHeight + Spacing.frameWidth
                }

                Item {
                    focus: screenRoot.panelActiveHere

                    Keys.onEscapePressed: {
                        Dispatcher.handleEscape()
                    }
                }
            }
        }
    }
}
