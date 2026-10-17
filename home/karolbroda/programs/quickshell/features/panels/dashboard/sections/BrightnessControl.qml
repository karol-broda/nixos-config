import QtQuick
import qs.services
import qs.widgets.containers

LevelRow {
    icon: Brightness.icon
    value: Brightness.brightness
    onMoved: value => Brightness.setBrightness(value)
}
