import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.widgets.text
import qs.widgets.indicators
import "sections"

Panel {
    id: root

    slideFrom: "top-right"
    open: screenActive && Dispatcher.activePanel === "dashboard"

    property bool screenActive: true

    targetWidth: 340
    targetHeight: content.implicitHeight + Spacing.panelPadding * 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        Title {
            text: "Dashboard"
        }

        VolumeSlider {
            Layout.fillWidth: true
        }

        BrightnessSlider {
            Layout.fillWidth: true
        }

        Separator {
            Layout.fillWidth: true
        }

        QuickToggles {
            Layout.fillWidth: true
        }

        Separator {
            Layout.fillWidth: true
        }

        MediaCard {
            Layout.fillWidth: true
        }

        WeatherCard {
            Layout.fillWidth: true
        }

        SystemInfo {
            Layout.fillWidth: true
        }
    }
}
