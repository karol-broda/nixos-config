import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.core
import qs.services
import "sections"

Panel {
    id: root

    property var menuEntry: null
    property int level: 0
    property bool closing: false

    slideFrom: "top"
    contentFade: false

    property bool _ready: false
    property bool _animateClose: false

    Component.onCompleted: {
        if (root.closing) {
            root.suppressAnimation = true
            _ready = true
            root.suppressAnimation = false
            _startClose.start()
        } else {
            _ready = true
        }
    }

    Timer {
        id: _startClose
        interval: 16
        onTriggered: root._animateClose = true
    }

    open: _ready && !_animateClose

    targetWidth: 200
    targetHeight: subMenuColumn.implicitHeight + Spacing.paddingSm * 2

    QsMenuOpener {
        id: subMenuOpener
        menu: root.menuEntry
    }

    Timer {
        id: _refreshTimer
        interval: 150
        onTriggered: {
            if (root.menuEntry === null || root.menuEntry === undefined) return
            var e = root.menuEntry
            subMenuOpener.menu = null
            subMenuOpener.menu = e
        }
    }

    ColumnLayout {
        id: subMenuColumn
        anchors.fill: parent
        anchors.margins: Spacing.paddingSm
        spacing: 0

        Repeater {
            id: subMenuRepeater
            model: subMenuOpener.children

            delegate: MenuEntry {
                onTriggered: _refreshTimer.restart()
                onSubMenuRequested: function(globalY) {
                    Tray.openSubMenu(modelData, root.x + root.width, globalY, root.level + 1)
                }
                onNonSubHovered: Tray.closeSubMenusFrom(root.level + 1)
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: Spacing.spacingXs
            visible: subMenuRepeater.count === 0
            text: "loading…"
            font.family: Typography.labelFamily
            font.pixelSize: Typography.sizeMicro
            font.italic: true
            color: Colors.textDim
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
