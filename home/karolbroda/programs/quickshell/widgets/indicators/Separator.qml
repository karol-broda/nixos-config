import QtQuick
import qs.theme

Rectangle {
    id: root

    property bool vertical: false

    implicitWidth: vertical ? 1 : parent.width
    implicitHeight: vertical ? parent.height : 1
    color: Colors.divider
}
