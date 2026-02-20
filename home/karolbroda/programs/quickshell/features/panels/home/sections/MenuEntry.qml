import QtQuick
import QtQuick.Layouts
import qs.theme

Item {
    id: root

    required property var modelData

    readonly property bool isSep: {
        if (modelData === null || modelData === undefined) return false
        return modelData.isSeparator === true
    }

    readonly property string label: {
        if (modelData === null || modelData === undefined) return ""
        if (modelData.text === null || modelData.text === undefined) return ""
        return modelData.text
    }

    readonly property bool isEnabled: {
        if (modelData === null || modelData === undefined) return false
        return modelData.enabled !== false
    }

    readonly property bool isCheckable: {
        if (modelData === null || modelData === undefined) return false
        var bt = modelData.buttonType
        return bt !== null && bt !== undefined && bt !== 0
    }

    readonly property bool isChecked: {
        if (modelData === null || modelData === undefined) return false
        return modelData.checkState === Qt.Checked
    }

    readonly property bool hasSub: {
        if (modelData === null || modelData === undefined) return false
        return modelData.hasChildren === true
    }

    signal triggered()
    signal subMenuRequested(real globalY)
    signal nonSubHovered()

    Layout.fillWidth: true
    Layout.preferredHeight: isSep ? sepRect.height : rowRect.height
    visible: isSep || label !== ""

    Rectangle {
        id: sepRect
        anchors.left: parent.left
        anchors.right: parent.right
        height: Spacing.spacingSm + 1
        color: "transparent"
        visible: root.isSep

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: 1
            color: Colors.divider
        }
    }

    Rectangle {
        id: rowRect
        anchors.left: parent.left
        anchors.right: parent.right
        height: 28
        radius: Spacing.radiusXs
        color: rowMouse.containsMouse && root.isEnabled ? Colors.bgHover : "transparent"
        visible: root.isSep !== true
        opacity: root.isEnabled ? 1.0 : 0.4

        Behavior on color {
            ColorAnimation { duration: Motion.hoverDuration }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Spacing.paddingSm
            anchors.rightMargin: Spacing.paddingSm
            spacing: Spacing.spacingSm

            Rectangle {
                Layout.preferredWidth: 14
                Layout.preferredHeight: 14
                radius: root.isCheckable ? 2 : 7
                color: "transparent"
                border.width: root.isCheckable ? 1 : 0
                border.color: root.isChecked ? Colors.accent : Colors.overlay0
                visible: root.isCheckable

                Rectangle {
                    anchors.centerIn: parent
                    width: 8
                    height: 8
                    radius: parent.radius > 2 ? 4 : 1
                    color: Colors.accent
                    visible: root.isChecked
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.label
                font.family: Typography.bodyTextFamily
                font.pixelSize: Typography.sizeLabel
                font.weight: Typography.weightRegular
                color: root.isEnabled ? Colors.textPrimary : Colors.textDim
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                visible: root.hasSub
                text: "\u203A"
                font.pixelSize: Typography.sizeBody
                color: Colors.textDim
            }
        }

        MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: root.isEnabled
            cursorShape: root.isEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onContainsMouseChanged: {
                if (containsMouse !== true) return
                if (root.isEnabled !== true) return

                if (root.hasSub) {
                    var pos = rowRect.mapToItem(null, 0, 0)
                    root.subMenuRequested(pos.y)
                } else {
                    root.nonSubHovered()
                }
            }

            onClicked: {
                if (root.isEnabled !== true) return
                if (root.modelData === null || root.modelData === undefined) return

                if (root.hasSub) {
                    var pos = rowRect.mapToItem(null, 0, 0)
                    root.subMenuRequested(pos.y)
                } else {
                    root.modelData.triggered()
                    root.triggered()
                }
            }
        }
    }
}
