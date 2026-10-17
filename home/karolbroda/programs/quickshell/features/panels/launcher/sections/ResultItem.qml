import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.icons
import qs.widgets.text
import qs.widgets.containers

Item {
    id: root

    required property var result
    property bool isSelected: false

    signal clicked()
    signal hovered()

    readonly property bool hasFilePreview: result.previewType === "file" && result.preview !== ""

    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radiusInner
        color: {
            if (root.isSelected) return Colors.withAlpha(Colors.accent, 0.15)
            if (mouseArea.containsMouse) return Colors.bgHover
            return "transparent"
        }
        border.width: root.isSelected ? 1 : 0
        border.color: Colors.withAlpha(Colors.accent, 0.3)

        Behavior on color {
            ColorAnimation { duration: Motion.hoverDuration }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Spacing.paddingSm
        anchors.rightMargin: Spacing.paddingSm
        spacing: Spacing.spacingMd

        Item {
            Layout.preferredWidth: root.hasFilePreview ? 52 : 32
            Layout.preferredHeight: 32

            Rectangle {
                anchors.centerIn: parent
                width: 52
                height: 32
                radius: Spacing.radiusNested
                color: Colors.surface0
                clip: true
                visible: root.hasFilePreview

                Image {
                    id: thumbnail
                    anchors.fill: parent
                    source: root.hasFilePreview ? "file://" + root.result.preview : ""
                    sourceSize.width: 128
                    sourceSize.height: 80
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: status === Image.Ready
                }

                DuotoneIcon {
                    anchors.centerIn: parent
                    name: "image"
                    size: Spacing.iconMd
                    iconState: root.isSelected ? "active" : "default"
                    visible: !thumbnail.visible
                }
            }

            AppIcon {
                anchors.centerIn: parent
                iconName: root.result.icon
                size: 28
                visible: !root.hasFilePreview && root.result.icon !== ""
            }

            DuotoneIcon {
                anchors.centerIn: parent
                name: root.result.providerIcon
                size: Spacing.iconMd
                iconState: root.isSelected ? "active" : "default"
                visible: !root.hasFilePreview && root.result.icon === ""
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Body {
                Layout.fillWidth: true
                text: root.result.label
                color: root.isSelected ? Colors.accent : Colors.textPrimary
            }

            Label {
                Layout.fillWidth: true
                text: root.result.sublabel
                visible: text !== ""
            }
        }

        Pill {
            Layout.preferredHeight: 20
            implicitWidth: providerLabel.implicitWidth + Spacing.paddingSm * 2
            visible: root.result.providerLabel !== "" && root.result.providerLabel !== "Apps"

            Label {
                id: providerLabel
                anchors.centerIn: parent
                text: root.result.providerLabel
                font.pixelSize: Typography.sizeMicro
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.clicked()
        onContainsMouseChanged: if (containsMouse) root.hovered()
    }
}
