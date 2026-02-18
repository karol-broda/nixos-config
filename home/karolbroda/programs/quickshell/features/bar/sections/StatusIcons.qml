import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.icons

RowLayout {
    id: root

    spacing: Spacing.spacingXs

    Item {
        Layout.preferredWidth: Spacing.iconMd
        Layout.preferredHeight: Spacing.iconMd

        DuotoneIcon {
            anchors.centerIn: parent
            name: Network.icon !== null && Network.icon !== undefined ? Network.icon : "wifi-slash"
            size: Spacing.iconSm
            iconState: !Network.ready || Network.connected === true ? "default" : "disabled"
        }
    }

    Item {
        Layout.preferredWidth: Spacing.iconMd
        Layout.preferredHeight: Spacing.iconMd

        DuotoneIcon {
            anchors.centerIn: parent
            name: Audio.icon !== null && Audio.icon !== undefined ? Audio.icon : "speaker-high"
            size: Spacing.iconSm
            iconState: Audio.muted === true ? "disabled" : "default"
        }
    }

    Item {
        Layout.preferredWidth: Spacing.iconMd
        Layout.preferredHeight: Spacing.iconMd
        visible: Battery.available === true

        DuotoneIcon {
            anchors.centerIn: parent
            name: Battery.icon !== null && Battery.icon !== undefined ? Battery.icon : "battery-full"
            size: Spacing.iconSm
            iconState: Battery.isLow === true ? "active" : "default"
        }
    }
}
