import QtQuick
import qs.theme
import qs.services

Text {
    id: root

    text: Time.format("HH:mm")
    font.family: Typography.barClockFamily
    font.pixelSize: Typography.barClockSize
    font.weight: Typography.barClockWeight
    font.letterSpacing: Typography.barClockSpacing
    color: Colors.textPrimary
    verticalAlignment: Text.AlignVCenter
}
