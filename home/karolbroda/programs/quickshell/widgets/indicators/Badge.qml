import QtQuick
import qs.theme

Rectangle {
    id: root

    property int count: 0
    property bool showZero: false

    visible: count > 0 || showZero
    implicitWidth: Math.max(16, badgeText.implicitWidth + 8)
    implicitHeight: 16
    radius: height / 2
    color: Colors.accent

    Text {
        id: badgeText
        anchors.centerIn: parent
        text: root.count > 99 ? "99+" : root.count.toString()
        color: Colors.crust
        font.family: Typography.bodyFamily
        font.pixelSize: Typography.sizeMicro
        font.weight: Typography.weightMedium
    }
}
