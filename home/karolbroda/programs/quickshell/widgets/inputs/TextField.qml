import QtQuick
import qs.theme

Rectangle {
    id: root

    property alias text: input.text
    property alias placeholderText: placeholder.text
    property alias inputFocus: input.activeFocus

    signal inputTextChanged(string newText)
    signal inputAccepted()

    implicitWidth: 200
    implicitHeight: 36
    radius: Spacing.radiusSm
    color: Colors.bgElevated
    border.width: input.activeFocus ? 2 : 0
    border.color: Colors.accent

    Behavior on border.width {
        NumberAnimation { duration: Motion.hoverDuration }
    }

    TextInput {
        id: input
        anchors.fill: parent
        anchors.leftMargin: Spacing.paddingMd
        anchors.rightMargin: Spacing.paddingMd
        verticalAlignment: TextInput.AlignVCenter
        color: Colors.textPrimary
        font.family: Typography.inputFamily
        font.pixelSize: Typography.inputSize
        font.letterSpacing: Typography.inputSpacing
        clip: true
        selectByMouse: true
        selectionColor: Colors.accent
        selectedTextColor: Colors.crust

        onTextChanged: root.inputTextChanged(text)
        onAccepted: root.inputAccepted()
    }

    Text {
        id: placeholder
        anchors.fill: input
        verticalAlignment: Text.AlignVCenter
        color: Colors.textDim
        font.family: Typography.placeholderFamily
        font.pixelSize: Typography.placeholderSize
        font.weight: Typography.placeholderWeight
        font.italic: true
        font.letterSpacing: Typography.placeholderSpacing
        visible: input.text === "" && input.activeFocus === false
    }

    function forceActiveFocus() {
        input.forceActiveFocus()
    }

    function clear() {
        input.text = ""
    }
}
