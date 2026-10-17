import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.icons
import qs.widgets.text

Rectangle {
    id: root

    property string icon: ""
    property string iconState: "default"
    property string title: ""
    property string subtitle: ""
    property string trailing: ""
    property bool selected: false

    signal clicked()

    implicitWidth: content.implicitWidth + Spacing.paddingSm * 2
    implicitHeight: content.implicitHeight + Spacing.paddingSm * 2
    radius: Spacing.radiusInner
    color: selected ? Colors.withAlpha(Colors.accent, mouseArea.containsMouse ? 0.2 : 0.12)
        : (mouseArea.containsMouse ? Colors.bgHover : "transparent")

    Behavior on color {
        ColorAnimation { duration: Motion.hoverDuration }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.paddingSm
        spacing: Spacing.spacingSm

        DuotoneIcon {
            visible: root.icon !== ""
            name: root.icon
            size: Spacing.iconSm
            iconState: root.iconState
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Body {
                Layout.fillWidth: true
                text: root.title
                color: root.selected ? Colors.accent : Colors.textPrimary
            }

            Label {
                Layout.fillWidth: true
                visible: root.subtitle !== ""
                text: root.subtitle
            }
        }

        Label {
            visible: root.trailing !== ""
            text: root.trailing
            color: root.selected ? Colors.accent : Colors.textMuted
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
