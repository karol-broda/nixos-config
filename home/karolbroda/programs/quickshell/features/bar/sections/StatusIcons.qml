import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.icons

RowLayout {
    id: root

    spacing: Spacing.spacingXs

    component StatusIcon: Item {
        property alias name: icon.name
        property alias iconState: icon.iconState

        Layout.preferredWidth: Spacing.iconMd
        Layout.preferredHeight: Spacing.iconMd

        DuotoneIcon {
            id: icon
            anchors.centerIn: parent
            size: Spacing.iconSm
        }
    }

    StatusIcon {
        name: Network.icon
        iconState: !Network.ready || Network.connected ? "default" : "disabled"
    }

    StatusIcon {
        name: Audio.icon
        iconState: Audio.muted ? "disabled" : "default"
    }

    StatusIcon {
        visible: Battery.available
        name: Battery.icon
        iconState: Battery.isLow ? "active" : "default"
    }
}
