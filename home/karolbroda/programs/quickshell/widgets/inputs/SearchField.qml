import QtQuick
import qs.theme
import qs.widgets.icons
import qs.widgets.buttons

Rectangle {
    id: root

    property alias text: input.text
    property string placeholder: "Search..."

    signal searchTextChanged(string newText)
    signal searchAccepted()
    signal escapePressed()

    implicitWidth: 300
    implicitHeight: 44
    radius: Spacing.radiusFull
    color: Colors.bgElevated
    border.width: input.activeFocus ? 2 : 1
    border.color: input.activeFocus ? Colors.accent : Colors.bgElevated

    Behavior on border.color {
        ColorAnimation { duration: Motion.hoverDuration }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: Spacing.paddingMd
        anchors.rightMargin: Spacing.paddingSm
        spacing: Spacing.spacingSm

        DuotoneIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: "magnifying-glass"
            size: Spacing.iconMd
            iconState: input.activeFocus ? "active" : "default"
        }

        TextInput {
            id: input
            width: parent.width - Spacing.iconMd - clearBtn.width - Spacing.spacingSm * 2
            height: parent.height
            verticalAlignment: TextInput.AlignVCenter
            color: Colors.textPrimary
            font.family: Typography.inputFamily
            font.pixelSize: Typography.inputSize
            font.letterSpacing: Typography.inputSpacing
            clip: true
            selectByMouse: true
            selectionColor: Colors.accent
            selectedTextColor: Colors.crust

            onTextChanged: root.searchTextChanged(text)
            onAccepted: root.searchAccepted()

            Keys.onEscapePressed: root.escapePressed()

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                text: root.placeholder
                color: Colors.textDim
                font.family: Typography.placeholderFamily
                font.pixelSize: Typography.placeholderSize
                font.weight: Typography.placeholderWeight
                font.italic: true
                font.letterSpacing: Typography.placeholderSpacing
                visible: parent.text === "" && parent.activeFocus === false
            }
        }

        IconButton {
            id: clearBtn
            anchors.verticalCenter: parent.verticalCenter
            icon: "x"
            size: Spacing.iconLg
            iconSize: Spacing.iconSm
            visible: input.text !== ""
            opacity: visible ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: Motion.hoverDuration }
            }

            onClicked: {
                input.text = ""
                input.forceActiveFocus()
            }
        }
    }

    function forceActiveFocus() {
        input.forceActiveFocus()
    }

    function clear() {
        input.text = ""
    }
}
