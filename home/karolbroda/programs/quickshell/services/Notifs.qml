pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property list<Notif> list: _state.list
    readonly property list<Notif> popups: _state.popups
    readonly property int count: list.length
    readonly property int maxPopups: 3

    property var _state: ({ list: [], popups: [] })

    function dismiss(n: Notif): void {
        if (!n || n._removed) return
        root._remove(n)
        n.notification?.dismiss()
    }

    function clearAll(): void {
        for (const n of root.list.slice()) root.dismiss(n)
    }

    function invokeAction(n: Notif, action: NotificationAction): void {
        if (!n || n._removed) return
        action?.invoke()
        root.dismiss(n)
    }

    function _remove(n: Notif): void {
        if (n._removed) return
        n._removed = true
        n._stopTimer()
        root._state = {
            list: root.list.filter(item => item !== n),
            popups: root.popups.filter(item => item !== n)
        }
        n.destroy()
    }

    function _showPopup(n: Notif): void {
        if (n._removed) return
        const visible = root.popups.filter(item => item !== n)
        while (visible.length >= root.maxPopups) visible.shift()._stopTimer()
        root._state = { list: root.list, popups: [...visible, n] }
        n._restartTimer()
    }

    function _hidePopup(n: Notif): void {
        root._state = { list: root.list, popups: root.popups.filter(item => item !== n) }
    }

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: true
        bodySupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notification => {
            notification.tracked = true
            const wrapper = notifComp.createObject(root, { notification: notification })
            if (!wrapper) {
                notification.dismiss()
                return
            }
            root._state = { list: [...root.list, wrapper], popups: root.popups }
            root._showPopup(wrapper)
        }
    }

    component Notif: QtObject {
        id: notif

        required property Notification notification
        readonly property int id: notification?.id ?? 0
        readonly property string appIcon: notification?.appIcon ?? ""
        readonly property string appName: notification?.appName || "Unknown"
        readonly property string summary: notification?.summary ?? ""
        readonly property string body: notification?.body ?? ""
        readonly property string image: notification?.image ?? ""
        readonly property int urgency: notification?.urgency ?? NotificationUrgency.Normal
        readonly property var _data: notification
        readonly property list<NotificationAction> actions: _data?.actions ?? []
        readonly property date time: _time
        readonly property string timeStr: {
            const minutes = Math.max(0, Math.floor((Time.date.getTime() - time.getTime()) / 60000))
            return minutes < 1 ? "now" : minutes < 60 ? minutes + "m" : Math.floor(minutes / 60) + "h"
        }
        readonly property bool popup: root.popups.includes(notif)

        property bool _removed: false
        property date _time: new Date()

        function _expirePopup(): void {
            notif._stopTimer()
            root._hidePopup(notif)
        }

        function _stopTimer(): void {
            expiry.stop()
        }

        function _restartTimer(): void {
            notif._time = new Date()
            expiry.restart()
        }

        readonly property Timer _timer: Timer {
            id: expiry
            interval: notif.notification?.expireTimeout > 0 ? notif.notification.expireTimeout : 5000
            onTriggered: notif._expirePopup()
        }

        readonly property Connections _changes: Connections {
            target: notif.notification
            function onSummaryChanged(): void { root._showPopup(notif) }
            function onBodyChanged(): void { root._showPopup(notif) }
            function onClosed(): void { root._remove(notif) }
        }

        readonly property Connections _retention: Connections {
            target: notif.notification?.Retainable ?? null
            function onDropped(): void { root._remove(notif) }
            function onAboutToDestroy(): void { root._remove(notif) }
        }
    }

    Component {
        id: notifComp
        Notif {}
    }
}
