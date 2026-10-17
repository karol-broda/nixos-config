pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.icons
import qs.widgets.text
import qs.widgets.buttons

ColumnLayout {
    id: root

    required property var notif
    property int bodyLines: 4
    property bool compact: false

    signal dismissRequested()
    signal actionInvoked(var action)

    spacing: Spacing.spacingSm

    RowLayout {
        Layout.fillWidth: true
        spacing: Spacing.spacingSm

        AppIcon {
            iconName: root.notif.appIcon
            size: Spacing.iconSm
        }

        Label {
            Layout.fillWidth: true
            text: root.notif.appName
            font.pixelSize: root.compact ? Typography.sizeCaption : Typography.labelSize
        }

        Label {
            text: root.notif.timeStr
            color: Colors.textDim
            font.pixelSize: root.compact ? Typography.sizeCaption : Typography.labelSize
        }

        IconButton {
            icon: "x"
            size: 24
            iconSize: Spacing.iconSm
            onClicked: root.dismissRequested()
        }
    }

    Heading {
        Layout.fillWidth: true
        text: root.notif.summary
        visible: text !== ""
        wrapMode: Text.Wrap
        maximumLineCount: 2
    }

    Body {
        Layout.fillWidth: true
        text: root.notif.body
        visible: text !== ""
        wrapMode: Text.Wrap
        maximumLineCount: root.bodyLines
        color: Colors.textSecondary
    }

    Flow {
        Layout.fillWidth: true
        spacing: Spacing.spacingSm
        visible: root.notif.actions.length > 0

        Repeater {
            model: root.notif.actions

            TextButton {
                required property var modelData

                text: modelData.text
                onClicked: root.actionInvoked(modelData)
            }
        }
    }
}
