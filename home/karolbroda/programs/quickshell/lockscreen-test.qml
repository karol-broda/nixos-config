import QtQuick
import Quickshell

import qs.features.lockscreen

ShellRoot {
    LockContext {
        id: lockContext
        onUnlocked: Qt.quit()
    }

    FloatingWindow {
        LockSurface {
            anchors.fill: parent
            context: lockContext
        }
    }

    Connections {
        target: Quickshell

        function onLastWindowClosed() {
            Qt.quit()
        }
    }
}
