import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.buttons
import qs.widgets.inputs
import qs.widgets.icons
import qs.widgets.text

RowLayout {
    id: root

    property string icon: ""
    property string iconState: "default"
    property real value: 0

    signal moved(real value)
    signal iconClicked()

    spacing: Spacing.spacingSm

    ButtonBase {
        implicitWidth: Spacing.iconMd
        implicitHeight: Spacing.iconMd
        onClicked: root.iconClicked()

        DuotoneIcon {
            anchors.centerIn: parent
            name: root.icon
            iconState: root.iconState
            size: Spacing.iconMd
        }
    }

    Slider {
        Layout.fillWidth: true
        value: root.value
        onMoved: value => root.moved(value)
    }

    Label {
        Layout.preferredWidth: 36
        text: Math.round(root.value * 100) + "%"
        horizontalAlignment: Text.AlignRight
    }
}
