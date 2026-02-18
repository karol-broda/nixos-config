import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.containers
import qs.widgets.icons
import qs.widgets.text

Card {
    id: root

    visible: Weather.loaded === true
    implicitHeight: visible ? weatherContent.implicitHeight + Spacing.paddingMd * 2 : 0

    Behavior on implicitHeight {
        NumberAnimation { duration: Motion.durationMedium }
    }

    RowLayout {
        id: weatherContent
        anchors.fill: parent
        spacing: Spacing.spacingMd

        DuotoneIcon {
            name: {
                const icon = Weather.icon
                if (icon === null || icon === undefined || icon === "") return "sun"
                return icon
            }
            size: Spacing.iconXl
            iconState: "active"
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingXs

            RowLayout {
                spacing: Spacing.spacingSm

                Mono {
                    text: {
                        const temp = Weather.temperature
                        if (temp === null || temp === undefined) return "--"
                        return temp + "°"
                    }
                    font.pixelSize: Typography.headingSize
                    font.weight: Typography.monoTextWeight
                }

                Label {
                    text: {
                        const cond = Weather.condition
                        return cond !== null && cond !== undefined ? cond : "Loading..."
                    }
                }
            }

            Label {
                text: {
                    const loc = Weather.location
                    return loc !== null && loc !== undefined ? loc : ""
                }
                visible: text !== ""
            }
        }
    }
}
