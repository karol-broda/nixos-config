pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import "sections"

ColumnLayout {
    id: root

    property var menu: null

    signal subMenuRequested(var entry, real globalY)
    signal plainEntryHovered()

    spacing: 0

    QsMenuOpener {
        id: opener
        menu: root.menu
    }

    Timer {
        id: refresh
        interval: 150
        onTriggered: {
            opener.menu = null
            opener.menu = Qt.binding(() => root.menu)
        }
    }

    Repeater {
        id: entries
        model: opener.children

        delegate: MenuEntry {
            id: entry

            onTriggered: refresh.restart()
            onSubMenuRequested: globalY => root.subMenuRequested(entry.modelData, globalY)
            onNonSubHovered: root.plainEntryHovered()
        }
    }

    Text {
        Layout.fillWidth: true
        Layout.topMargin: Spacing.spacingXs
        visible: entries.count === 0
        text: "loading…"
        font.family: Typography.labelFamily
        font.pixelSize: Typography.sizeMicro
        font.italic: true
        color: Colors.textDim
        horizontalAlignment: Text.AlignHCenter
    }
}
