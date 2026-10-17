pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.core
import qs.theme
import qs.services
import qs.state
import qs.features.osd
import qs.features.toasts
import qs.features.panels.home
import qs.features.panels.dashboard
import qs.features.panels.launcher
import qs.features.panels.notifications

PanelWindow {
    id: root

    required property ShellScreen modelData

    readonly property string screenName: modelData.name
    readonly property bool panelOpen: Shell.isActiveOn(screenName)
    readonly property bool isFocused: Shell.focusedScreen === screenName
    readonly property string openPanel: panelOpen ? Shell.current.panel : ""

    screen: modelData
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-overlay"
    WlrLayershell.keyboardFocus: panelOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    mask: Region {
        item: root.panelOpen ? scope : toasts
    }

    HyprlandFocusGrab {
        active: root.panelOpen
        windows: [root]
        onCleared: Shell.closePanel()
    }

    onOpenPanelChanged: {
        if (openPanel === "launcher")
            Qt.callLater(launcherContent.focusInput);
        else if (openPanel !== "")
            Qt.callLater(scope.forceActiveFocus);
    }

    FocusScope {
        id: scope

        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: Shell.handleEscape()

        MouseArea {
            anchors.fill: parent
            enabled: root.panelOpen
            onClicked: Shell.closePanel()
        }

        SurfaceLayer {
            id: layer

            anchors.fill: parent
            aperture: Qt.rect(Spacing.panelSideInset, Spacing.panelTopInset, width - Spacing.panelSideInset * 2, height - Spacing.panelTopInset - Spacing.panelSideInset)
            clipTop: Spacing.barHeight
            frameVisible: {
                const workspace = Hypr.monitorFor(root.modelData)?.activeWorkspace;
                return !(workspace?.toplevels.values ?? []).some(client => ((client.lastIpcObject?.fullscreen ?? 0) & 2) !== 0);
            }

            Surface {
                id: home

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: Spacing.panelSideInset
                anchors.topMargin: Spacing.panelTopInset

                edge: "top-left"
                open: root.openPanel === "home"
                contentWidth: homeContent.implicitWidth
                contentHeight: homeContent.implicitHeight

                HomePanel {
                    id: homeContent
                    anchors.fill: parent
                }
            }

            Surface {
                id: flyout

                x: home.x + home.width
                anchors.top: parent.top
                anchors.topMargin: Spacing.panelTopInset

                edge: "top-left"
                open: home.open && Tray.activeMenuItem !== null
                contentWidth: flyoutContent.implicitWidth
                contentHeight: flyoutContent.implicitHeight

                TrayFlyout {
                    id: flyoutContent
                    anchors.fill: parent
                    onSubMenuRequested: (entry, globalY) => menuStack.openAt(0, entry, flyout.x + flyout.width, globalY)
                    onPlainEntryHovered: menuStack.closeFrom(0)
                }
            }

            TrayMenuStack {
                id: menuStack
            }

            Repeater {
                model: ScriptModel {
                    values: [...menuStack.levels]
                }

                Surface {
                    id: submenu

                    required property var modelData

                    x: modelData.x
                    y: modelData.y
                    edge: "top"
                    fadeContent: false
                    open: modelData.open && flyout.open
                    contentWidth: 200
                    contentHeight: submenuList.implicitHeight + Spacing.menuPadding * 2

                    onShownChanged: if (!shown)
                        menuStack.forget(modelData)

                    MenuList {
                        id: submenuList
                        anchors.fill: parent
                        anchors.margins: Spacing.menuPadding
                        menu: submenu.modelData.entry
                        onSubMenuRequested: (entry, globalY) => {
                            menuStack.openAt(submenu.modelData.depth + 1, entry, submenu.x + submenu.width, globalY);
                        }
                        onPlainEntryHovered: menuStack.closeFrom(submenu.modelData.depth + 1)
                    }
                }
            }

            Surface {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Spacing.panelTopInset

                edge: "top"
                open: root.openPanel === "launcher"
                contentWidth: launcherContent.implicitWidth
                contentHeight: launcherContent.implicitHeight

                LauncherPanel {
                    id: launcherContent
                    anchors.fill: parent
                }
            }

            Surface {
                id: rightSlot

                readonly property bool wants: root.openPanel === "dashboard" || root.openPanel === "notifications"
                property string page: "dashboard"

                Connections {
                    target: root
                    function onOpenPanelChanged(): void {
                        if (rightSlot.wants)
                            rightSlot.page = root.openPanel;
                    }
                }

                readonly property Item pageItem: page === "dashboard" ? dashboard : notifications

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: Spacing.panelSideInset
                anchors.topMargin: Spacing.panelTopInset

                edge: "top-right"
                open: wants
                contentWidth: pageItem.implicitWidth
                contentHeight: pageItem.implicitHeight

                DashboardPanel {
                    id: dashboard
                    anchors.right: parent.right
                    width: implicitWidth
                    height: implicitHeight
                    active: rightSlot.open && rightSlot.page === "dashboard"
                    opacity: rightSlot.page === "dashboard" ? 1 : 0
                    visible: opacity > 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Motion.durationNormal
                        }
                    }
                }

                NotifPanel {
                    id: notifications
                    anchors.right: parent.right
                    width: implicitWidth
                    height: implicitHeight
                    opacity: rightSlot.page === "notifications" ? 1 : 0
                    visible: opacity > 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Motion.durationNormal
                        }
                    }
                }
            }

            Surface {
                id: toasts

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: Spacing.panelSideInset
                anchors.topMargin: Spacing.panelTopInset

                edge: "top-right"
                open: root.isFocused && Notifs.popups.length > 0 && !rightSlot.shown
                contentWidth: toastContent.implicitWidth
                contentHeight: toastContent.implicitHeight

                ToastStack {
                    id: toastContent
                    anchors.fill: parent
                }
            }

            Surface {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Spacing.panelSideInset

                edge: "bottom"
                interactive: false
                open: root.isFocused && OsdState.kind !== ""
                contentWidth: osdContent.implicitWidth
                contentHeight: osdContent.implicitHeight

                OsdContent {
                    id: osdContent
                    anchors.fill: parent
                }
            }
        }
    }
}
