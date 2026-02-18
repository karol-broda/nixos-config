import QtQuick
import qs.theme

Behavior on opacity {
    NumberAnimation {
        duration: Motion.glowDuration
        easing.type: Easing.OutQuad
    }
}
