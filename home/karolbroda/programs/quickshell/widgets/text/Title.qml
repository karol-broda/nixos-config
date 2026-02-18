import QtQuick
import qs.theme

Text {
    id: root

    color: Colors.textPrimary
    font.family: Typography.titleFamily
    font.pixelSize: Typography.titleSize
    font.weight: Typography.titleWeight
    font.letterSpacing: Typography.titleSpacing
    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
}
