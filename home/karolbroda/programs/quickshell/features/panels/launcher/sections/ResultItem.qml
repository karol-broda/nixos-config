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
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32

            AppIcon {
                anchors.centerIn: parent
                iconName: {
                    if (root.result === null || root.result === undefined) return ""
                    return root.result.icon || ""
                }
                size: 28
                visible: iconName !== ""
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
