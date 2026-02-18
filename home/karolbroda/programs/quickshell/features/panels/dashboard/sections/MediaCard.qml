import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.containers
import qs.widgets.icons
import qs.widgets.indicators
import qs.widgets.text
import qs.widgets.buttons

Card {
    id: root

    visible: Players.hasPlayer === true
    implicitHeight: visible ? mediaContent.implicitHeight + Spacing.paddingMd * 2 : 0

    Behavior on implicitHeight {
        NumberAnimation { duration: Motion.durationMedium }
    }

    CavaVisualizer {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.8
        opacity: 0.3
    }

    RowLayout {
        id: mediaContent
        anchors.fill: parent
        spacing: Spacing.spacingMd

        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: Spacing.radiusSm
            color: Colors.bgSecondary
            clip: true

            Image {
                anchors.fill: parent
                source: {
                    if (Players.hasPlayer !== true) return ""
                    const url = Players.active.trackArtUrl
                    return url !== null && url !== undefined ? url : ""
                }
                fillMode: Image.PreserveAspectCrop
                visible: source !== ""
            }

            DuotoneIcon {
                anchors.centerIn: parent
                name: "music-note"
                size: Spacing.iconMd
                iconState: "default"
                visible: {
                    if (Players.hasPlayer !== true) return true
                    const url = Players.active.trackArtUrl
                    return url === null || url === undefined || url === ""
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingXs

            Body {
                Layout.fillWidth: true
                text: {
                    if (Players.hasPlayer !== true) return "Not Playing"
                    const title = Players.active.trackTitle
                    return title !== null && title !== undefined && title !== "" ? title : "Not Playing"
                }
                elide: Text.ElideRight
            }

            Label {
                Layout.fillWidth: true
                text: {
                    if (Players.hasPlayer !== true) return ""
                    const artist = Players.active.trackArtist
                    return artist !== null && artist !== undefined ? artist : ""
                }
                elide: Text.ElideRight
                visible: text !== ""
            }
        }

        RowLayout {
            spacing: Spacing.spacingXs

            IconButton {
                icon: "skip-back"
                size: 32
                iconSize: Spacing.iconSm
                onClicked: Dispatcher.dispatch(Actions.prevTrack())
            }

            IconButton {
                icon: {
                    if (Players.hasPlayer !== true) return "play"
                    return Players.isPlaying === true ? "pause" : "play"
                }
                size: 36
                iconSize: Spacing.iconMd
                onClicked: Dispatcher.dispatch(Actions.playPause())
            }

            IconButton {
                icon: "skip-forward"
                size: 32
                iconSize: Spacing.iconSm
                onClicked: Dispatcher.dispatch(Actions.nextTrack())
            }
        }
    }
}
