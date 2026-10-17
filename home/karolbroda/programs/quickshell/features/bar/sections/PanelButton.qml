import QtQuick
import qs.theme
import qs.state
import qs.widgets.buttons

IconButton {
    id: root

    required property string panel
    property var screen: null

    size: Spacing.barHeight - 4
    iconSize: Spacing.iconMd
    active: Shell.isOpen(panel, screen?.name ?? "")

    onClicked: Shell.togglePanel(panel)
}
