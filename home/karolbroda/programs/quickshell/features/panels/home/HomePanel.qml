import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.text
import qs.widgets.indicators
import "sections"

Item {
    id: root

    implicitWidth: 280
    implicitHeight: content.implicitHeight + Spacing.panelPadding * 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        Title {
            text: "Home"
        }

        TrayGrid {
            Layout.fillWidth: true
        }

        Separator {
            Layout.fillWidth: true
        }

        PowerRow {
            Layout.fillWidth: true
        }
    }
}
