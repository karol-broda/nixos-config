import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services

Item {
    id: root

    signal subMenuRequested(var entry, real globalY)
    signal plainEntryHovered()

    implicitWidth: 220
    implicitHeight: column.implicitHeight + Spacing.menuPadding * 2

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: Spacing.menuPadding
        spacing: 0

        Text {
            id: tooltipLabel
            Layout.fillWidth: true
            Layout.bottomMargin: Spacing.spacingXs
            text: Tray.tooltip(Tray.activeMenuItem)
            font.family: Typography.labelFamily
            font.pixelSize: Typography.sizeMicro
            font.letterSpacing: Typography.microLabelSpacing
            color: Colors.textDim
            elide: Text.ElideRight
            visible: text !== ""
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.bottomMargin: Spacing.spacingXs
            implicitHeight: 1
            color: Colors.divider
            visible: tooltipLabel.visible
        }

        MenuList {
            Layout.fillWidth: true
            menu: Tray.activeMenu
            onSubMenuRequested: (entry, globalY) => root.subMenuRequested(entry, globalY)
            onPlainEntryHovered: root.plainEntryHovered()
        }
    }
}
