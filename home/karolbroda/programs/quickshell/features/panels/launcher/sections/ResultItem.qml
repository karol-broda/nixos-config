import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.widgets.icons
import qs.widgets.text
import qs.widgets.containers

Item {
    id: root

    property var result: null
    property bool isSelected: false

    signal clicked()
    signal hovered()

    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radiusSm
        color: {
            if (root.isSelected) {
                return Colors.withAlpha(Colors.accent, 0.15)
            }
            if (mouseArea.containsMouse) {
                return Colors.bgHover
            }
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
            id: iconSlot
            Layout.preferredWidth: iconSlot.hasFilePreview ? 52 : 32
            Layout.preferredHeight: 32

            readonly property bool hasFilePreview: {
                if (root.result === null || root.result === undefined) return false
                const preview = root.result.preview
                const previewType = root.result.previewType
                return preview !== null && preview !== undefined && preview !== ""
                    && previewType === "file"
            }

            Rectangle {
                anchors.centerIn: parent
                width: 52
                height: 32
                radius: Spacing.radiusMd
                color: Colors.surface0
                clip: true
                visible: iconSlot.hasFilePreview

                Image {
                    id: thumbnailImage
                    anchors.fill: parent
                    source: iconSlot.hasFilePreview ? "file://" + root.result.preview : ""
                    sourceSize.width: 128
                    sourceSize.height: 80
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    asynchronous: true
                    visible: status === Image.Ready
                }

                DuotoneIcon {
                    anchors.centerIn: parent
                    name: "image"
                    size: Spacing.iconMd
                    iconState: root.isSelected ? "active" : "default"
                    visible: thumbnailImage.status !== Image.Ready
                }
            }

            AppIcon {
                anchors.centerIn: parent
                iconName: {
                    if (root.result === null || root.result === undefined) return ""
                    return root.result.icon || ""
                }
                size: 28
                visible: !iconSlot.hasFilePreview && iconName !== ""
            }

            DuotoneIcon {
                anchors.centerIn: parent
                name: {
                    if (root.result === null || root.result === undefined) return "app-window"
                    return root.result.providerIcon || "app-window"
                }
                size: Spacing.iconMd
                iconState: root.isSelected ? "active" : "default"
                visible: {
                    if (iconSlot.hasFilePreview) return false
                    if (root.result === null || root.result === undefined) return true
                    const icon = root.result.icon
                    return icon === null || icon === undefined || icon === ""
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Body {
                Layout.fillWidth: true
                text: {
                    if (root.result === null || root.result === undefined) return ""
                    return root.result.label || ""
                }
                color: root.isSelected ? Colors.accent : Colors.textPrimary
                elide: Text.ElideRight
            }

            Label {
                Layout.fillWidth: true
                text: {
                    if (root.result === null || root.result === undefined) return ""
                    return root.result.sublabel || ""
                }
                visible: text !== ""
                elide: Text.ElideRight
            }
        }

        Pill {
            Layout.preferredHeight: 20
            implicitWidth: providerLabel.implicitWidth + Spacing.paddingSm * 2
            visible: {
                if (root.result === null || root.result === undefined) return false
                const label = root.result.providerLabel
                return label !== null && label !== undefined && label !== "" && label !== "Apps"
            }

            Label {
                id: providerLabel
                anchors.centerIn: parent
                text: {
                    if (root.result === null || root.result === undefined) return ""
                    return root.result.providerLabel || ""
                }
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
        onContainsMouseChanged: {
            if (containsMouse) {
                root.hovered()
            }
        }
    }
}
