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
        name: Audio.icon !== null && Audio.icon !== undefined ? Audio.icon : "speaker-high"
        size: Spacing.iconMd
        iconState: Audio.muted === true ? "disabled" : "default"

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Dispatcher.dispatch(Actions.toggleMute())
        }
    }

    Slider {
        Layout.fillWidth: true
        value: Audio.volume !== null && Audio.volume !== undefined ? Audio.volume : 0

        onUserValueChanged: function(newValue) {
            Dispatcher.dispatch(Actions.setVolume(newValue))
        }
    }

    Label {
        Layout.preferredWidth: 36
        text: Math.round((Audio.volume !== null && Audio.volume !== undefined ? Audio.volume : 0) * 100) + "%"
        horizontalAlignment: Text.AlignRight
    }
}
