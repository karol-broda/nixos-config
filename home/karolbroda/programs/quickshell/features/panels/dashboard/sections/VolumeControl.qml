pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.containers

ColumnLayout {
    id: root

    property bool sinkPickerOpen: false

    spacing: Spacing.spacingXs

    LevelRow {
        Layout.fillWidth: true
        icon: Audio.icon
        iconState: Audio.muted ? "disabled" : "default"
        value: Audio.volume
        onMoved: value => Audio.setVolume(value)
        onIconClicked: Audio.toggleMute()
    }

    ExpandableSection {
        Layout.fillWidth: true
        visible: Audio.sinks.length > 1
        icon: "speaker-high"
        title: Audio.sinkName
        titleColor: Colors.textMuted
        expanded: root.sinkPickerOpen
        onToggled: root.sinkPickerOpen = !root.sinkPickerOpen

        Repeater {
            model: Audio.sinks

            ChoiceRow {
                required property var modelData

                Layout.fillWidth: true
                icon: "speaker-high"
                title: modelData.description || modelData.name || ""
                selected: modelData === Audio.sink
                trailing: selected ? "Active" : ""
                visible: title !== ""
                onClicked: Audio.setAudioSink(modelData)
            }
        }
    }
}
