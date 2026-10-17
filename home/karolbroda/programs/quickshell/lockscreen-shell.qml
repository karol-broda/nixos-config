import QtQuick
import Quickshell
import qs.features.lockscreen

ShellRoot {
    id: root

    property bool done: false

    LockScreen {
        locked: !root.done
        onUnlocked: {
            root.done = true
            Qt.quit()
        }
    }
}
