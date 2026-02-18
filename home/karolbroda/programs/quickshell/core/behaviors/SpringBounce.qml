import QtQuick
import qs.theme

Behavior on scale {
    NumberAnimation {
        duration: Motion.durationMedium
        easing.type: Easing.OutBack
        easing.overshoot: 1.2
    }
}
