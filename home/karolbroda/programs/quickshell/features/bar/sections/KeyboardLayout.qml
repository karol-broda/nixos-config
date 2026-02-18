import QtQuick
import qs.theme
import qs.services

Item {
    id: root

    readonly property string layout: Keyboard.layout !== null && Keyboard.layout !== undefined
        ? Keyboard.layout.toUpperCase()
        : "??"

    implicitWidth: sizer.width
    implicitHeight: label.implicitHeight

    TextMetrics {
        id: sizer
        font: label.font
        text: "WW"
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.layout
        font.family: Typography.labelFamily
        font.pixelSize: Typography.labelSize
        font.weight: Typography.weightMedium
        font.letterSpacing: Typography.letterSpacingExtraWide
        color: Colors.textMuted
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
