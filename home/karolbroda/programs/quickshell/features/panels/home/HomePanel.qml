import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.text
import "sections"

Panel {
    id: root

    slideFrom: "top-left"
    open: screenActive && Dispatcher.activePanel === "home"

    property bool screenActive: true
    readonly property bool isOpen: open

    targetWidth: 280
    targetHeight: mainContent.implicitHeight + Spacing.panelPadding * 2

    ColumnLayout {
        id: mainContent
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        Title {
            text: "Home"
        }

        TrayGrid {
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.divider
        }

        PowerRow {
            Layout.fillWidth: true
        }
    }
}
