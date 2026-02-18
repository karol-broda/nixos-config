import QtQuick
import qs.theme
import qs.core
import qs.services
import "sections"

Panel {
    id: root

    slideFrom: "top-left"
    open: panelOpen && Tray.activeMenuHandle !== null

    property bool panelOpen: false

    targetWidth: 220
    targetHeight: trayMenu.implicitHeight + Spacing.panelPadding * 2

    onPanelOpenChanged: {
        if (panelOpen !== true) {
            Tray.closeMenu()
        }
    }

    TrayMenu {
        id: trayMenu
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding

        menuHandle: Tray.activeMenuHandle
        trayItemData: Tray.activeMenuItem
        flyoutRightEdge: root.x + root.width

        onClosed: Tray.closeMenu()
    }
}
