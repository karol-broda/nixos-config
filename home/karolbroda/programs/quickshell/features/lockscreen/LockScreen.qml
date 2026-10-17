pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    property bool locked: false
    signal unlocked()

    onLockedChanged: lockContext?.clearPassword()

    LockContext {
        id: lockContext
        onUnlocked: root.unlocked()
    }

    WlSessionLock {
        locked: root.locked

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }
}
