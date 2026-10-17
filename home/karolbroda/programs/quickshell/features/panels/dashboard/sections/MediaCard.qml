import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.containers
import qs.widgets.icons
import qs.widgets.indicators
import qs.widgets.text
import qs.widgets.buttons

Card {
    id: root

    property bool active: false

    visible: Players.hasPlayer
    implicitHeight: mediaContent.implicitHeight + Spacing.paddingMd * 2

    CavaVisualizer {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.8
        opacity: 0.3
        active: root.active && Players.isPlaying
    }

    RowLayout {
        id: mediaContent
        anchors.fill: parent
        spacing: Spacing.spacingMd

        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: Spacing.radiusNested
            color: Colors.bgSecondary
            clip: true

            Image {
                id: art
                anchors.fill: parent
                source: Players.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                visible: status === Image.Ready
            }

            DuotoneIcon {
                anchors.centerIn: parent
                name: "music-note"
                size: Spacing.iconMd
                visible: !art.visible
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingXs

            Body {
                Layout.fillWidth: true
                text: Players.title || "Not Playing"
            }

            Label {
                Layout.fillWidth: true
                text: Players.artist
                visible: text !== ""
            }
        }

        RowLayout {
            spacing: Spacing.spacingXs

            IconButton {
                icon: "skip-back"
                size: 32
                iconSize: Spacing.iconSm
                onClicked: Players.previous()
            }

            IconButton {
                icon: Players.isPlaying ? "pause" : "play"
                size: 36
                iconSize: Spacing.iconMd
                onClicked: Players.togglePlaying()
            }

            IconButton {
                icon: "skip-forward"
                size: 32
                iconSize: Spacing.iconSm
                onClicked: Players.next()
            }
        }
    }
}
