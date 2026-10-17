import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import "sections"

Rectangle {
    id: root

    required property ShellScreen screen

    implicitHeight: Spacing.barHeight
    color: Colors.barBg

    Workspaces {
        anchors.centerIn: parent
        screen: root.screen
    }

    RowLayout {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: Spacing.barPadding + Spacing.frameWidth
        spacing: Spacing.barItemSpacing

        PanelButton {
            panel: "home"
            icon: "house"
            screen: root.screen
        }

        PanelButton {
            panel: "launcher"
            icon: "magnifying-glass"
            screen: root.screen
        }

        PinnedApps {}

        BarVisualizer {}
    }

    RowLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: Spacing.barPadding + Spacing.frameWidth
        spacing: Spacing.barItemSpacing

        PanelButton {
            panel: "dashboard"
            icon: "sliders-horizontal"
            screen: root.screen
        }

        NotifBadge {
            screen: root.screen
        }

        KeyboardLayout {}

        StatusIcons {}

        Clock {}
    }
}
