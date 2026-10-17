import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.icons
import qs.widgets.text

Item {
    id: root

    property string icon: ""
    property string iconState: "default"
    property string title: ""
    property color titleColor: Colors.textPrimary
    property bool expanded: false
    default property alias content: contentColumn.data

    signal toggled()

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight
    clip: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.panelResizeDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Motion.curveSmooth
        }
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Spacing.spacingSm

        Rectangle {
            Layout.fillWidth: true
            implicitWidth: header.implicitWidth + Spacing.paddingSm * 2
            implicitHeight: header.implicitHeight + Spacing.paddingSm * 2
            radius: Spacing.radiusInner
            color: mouseArea.containsMouse ? Colors.bgHover : "transparent"

            Behavior on color {
                ColorAnimation { duration: Motion.hoverDuration }
            }

            RowLayout {
                id: header
                anchors.fill: parent
                anchors.margins: Spacing.paddingSm
                spacing: Spacing.spacingSm

                DuotoneIcon {
                    visible: root.icon !== ""
                    name: root.icon
                    size: Spacing.iconSm
                    iconState: root.iconState
                }

                Label {
                    Layout.fillWidth: true
                    text: root.title
                    color: root.titleColor
                }

                DuotoneIcon {
                    name: root.expanded ? "caret-down" : "caret-right"
                    size: Spacing.iconSm
                    iconState: mouseArea.containsMouse ? "hover" : "default"
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggled()
            }
        }

        ColumnLayout {
            id: contentColumn
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 2
        }
    }
}
