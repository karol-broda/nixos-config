import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import "sections"

Rectangle {
    id: root

    property var screen: null

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

        HomeButton {}
        SearchButton {}
        PinnedApps {}
        BarVisualizer {}
    }

    RowLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: Spacing.barPadding + Spacing.frameWidth
        spacing: Spacing.barItemSpacing

        DashboardButton {}
        NotifBadge {}
        KeyboardLayout {}
        StatusIcons {}
        Clock {}
    }
}
