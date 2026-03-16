import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.icons
import qs.widgets.inputs
import qs.widgets.text

ColumnLayout {
    id: root

    spacing: Spacing.spacingXs

    property bool sinkPickerOpen: false

    RowLayout {
        Layout.fillWidth: true
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

    Rectangle {
        id: sinkHeader
        Layout.fillWidth: true
        implicitHeight: sinkHeaderContent.implicitHeight + Spacing.paddingXs * 2
        radius: Spacing.radiusSm
        color: sinkHeaderMouse.containsMouse ? Colors.bgHover : "transparent"
        visible: Audio.sinks.length > 1

        Behavior on color {
            ColorAnimation { duration: Motion.hoverDuration }
        }

        RowLayout {
            id: sinkHeaderContent
            anchors.fill: parent
            anchors.leftMargin: Spacing.paddingSm
            anchors.rightMargin: Spacing.paddingSm
            anchors.topMargin: Spacing.paddingXs
            anchors.bottomMargin: Spacing.paddingXs
            spacing: Spacing.spacingSm

            Label {
                Layout.fillWidth: true
                text: Audio.sink !== null && Audio.sink !== undefined ? (Audio.sink.description || Audio.sink.name || "Unknown") : "No output"
                elide: Text.ElideRight
            }

            DuotoneIcon {
                name: root.sinkPickerOpen ? "caret-down" : "caret-right"
                size: Spacing.iconXs
                iconState: sinkHeaderMouse.containsMouse ? "hover" : "default"
            }
        }

        MouseArea {
            id: sinkHeaderMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                root.sinkPickerOpen = !root.sinkPickerOpen
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        visible: root.sinkPickerOpen
        spacing: 2

        Repeater {
            model: Audio.sinks

            delegate: Rectangle {
                id: sinkItem

                required property var modelData

                readonly property bool isActive: Audio.sink !== null && Audio.sink !== undefined && modelData !== null && modelData !== undefined && modelData === Audio.sink
                readonly property string sinkName: modelData !== null && modelData !== undefined ? (modelData.description || modelData.name || "") : ""

                Layout.fillWidth: true
                implicitHeight: sinkName !== "" ? sinkRow.implicitHeight + Spacing.paddingSm * 2 : 0
                radius: Spacing.radiusSm
                visible: sinkName !== ""

                color: {
                    if (isActive) return Colors.withAlpha(Colors.accent, sinkMouse.containsMouse ? 0.2 : 0.12)
                    return sinkMouse.containsMouse ? Colors.bgHover : "transparent"
                }

                Behavior on color {
                    ColorAnimation { duration: Motion.hoverDuration }
                }

                RowLayout {
                    id: sinkRow
                    anchors.fill: parent
                    anchors.leftMargin: Spacing.paddingSm
                    anchors.rightMargin: Spacing.paddingSm
                    anchors.topMargin: Spacing.paddingSm
                    anchors.bottomMargin: Spacing.paddingSm
                    spacing: Spacing.spacingSm

                    DuotoneIcon {
                        name: "speaker-high"
                        size: Spacing.iconSm
                        iconState: sinkItem.isActive ? "active" : "default"
                    }

                    Body {
                        Layout.fillWidth: true
                        text: sinkItem.sinkName
                        color: sinkItem.isActive ? Colors.accent : Colors.textPrimary
                        elide: Text.ElideRight
                    }

                    DuotoneIcon {
                        visible: sinkItem.isActive
                        name: "check"
                        size: Spacing.iconSm
                        iconState: "active"
                    }
                }

                MouseArea {
                    id: sinkMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Audio.setAudioSink(sinkItem.modelData)
                    }
                }
            }
        }
    }
}
