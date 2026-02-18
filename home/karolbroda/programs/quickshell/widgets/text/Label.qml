import QtQuick
import qs.theme

Text {
    id: root

    color: Colors.textMuted
    font.family: Typography.labelFamily
    font.pixelSize: Typography.labelSize
    font.weight: Typography.labelWeight
    font.letterSpacing: Typography.labelSpacing
    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
}
