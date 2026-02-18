import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.icons
import qs.widgets.inputs
import qs.widgets.text

RowLayout {
    id: root

    spacing: Spacing.spacingMd

    DuotoneIcon {
        name: Brightness.icon !== null && Brightness.icon !== undefined ? Brightness.icon : "sun"
        size: Spacing.iconMd
        iconState: "default"
    }

    Slider {
        Layout.fillWidth: true
        value: Brightness.brightness !== null && Brightness.brightness !== undefined ? Brightness.brightness : 0.5

        onUserValueChanged: function(newValue) {
            Dispatcher.dispatch(Actions.setBrightness(newValue))
        }
    }

    Label {
        Layout.preferredWidth: 36
        text: Math.round((Brightness.brightness !== null && Brightness.brightness !== undefined ? Brightness.brightness : 0.5) * 100) + "%"
        horizontalAlignment: Text.AlignRight
    }
}
