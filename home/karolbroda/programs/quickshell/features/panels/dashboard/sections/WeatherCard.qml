import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.containers
import qs.widgets.icons
import qs.widgets.text

Card {
    id: root

    visible: Weather.loaded
    implicitHeight: weatherContent.implicitHeight + Spacing.paddingMd * 2

    RowLayout {
        id: weatherContent
        anchors.fill: parent
        spacing: Spacing.spacingMd

        DuotoneIcon {
            name: Weather.icon
            size: Spacing.iconXl
            iconState: "active"
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingXs

            RowLayout {
                spacing: Spacing.spacingSm

                Mono {
                    text: Weather.temperature + "°"
                    font.pixelSize: Typography.headingSize
                    font.weight: Typography.monoTextWeight
                }

                Label {
                    text: Weather.condition
                }
            }

            Label {
                text: Weather.location
                visible: text !== ""
            }
        }
    }
}
