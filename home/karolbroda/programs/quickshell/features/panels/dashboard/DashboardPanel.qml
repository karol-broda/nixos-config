import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.text
import qs.widgets.indicators
import "sections"

Item {
    id: root

    property bool active: false

    implicitWidth: 340
    implicitHeight: content.implicitHeight + Spacing.panelPadding * 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        Title {
            text: "Dashboard"
        }

        VolumeControl {
            Layout.fillWidth: true
        }

        BrightnessControl {
            Layout.fillWidth: true
        }

        Separator {
            Layout.fillWidth: true
        }

        QuickToggles {
            Layout.fillWidth: true
            active: root.active
        }

        Separator {
            Layout.fillWidth: true
        }

        MediaCard {
            Layout.fillWidth: true
            active: root.active
        }

        WeatherCard {
            Layout.fillWidth: true
        }

        SystemInfo {
            Layout.fillWidth: true
            active: root.active
        }
    }
}
