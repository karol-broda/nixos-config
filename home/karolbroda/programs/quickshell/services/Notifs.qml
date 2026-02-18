pragma Singleton
pragma ComponentBehavior: Bound

import qs.services
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property list<Notif> list: []
    readonly property list<Notif> popups: list.filter(n => n.popup === true)

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true

            root.list.push(notifComp.createObject(root, {
                popup: true,
                notification: notif
            }))
        }
    }

    function clearAll() {
        const snapshot = root.list.slice()
        for (let idx = 0; idx < snapshot.length; idx++) {
            const notif = snapshot[idx]
            if (notif !== null && notif !== undefined) {
                notif.dismiss()
            }
        }
    }

    function dismissById(notifId) {
        if (notifId === null || notifId === undefined) {
            return
        }
        for (let idx = 0; idx < root.list.length; idx++) {
            const notif = root.list[idx]
            if (notif !== null && notif !== undefined && notif.id === notifId) {
                notif.dismiss()
                return
            }
        }
    }

    component Notif: QtObject {
        id: notif

        property bool popup
        readonly property int id: notification.id
        readonly property date time: new Date()
        readonly property string timeStr: {
            const diff = Time.date !== null && Time.date !== undefined ? Time.date.getTime() - time.getTime() : 0
            const m = Math.floor(diff / 60000)
            const h = Math.floor(m / 60)

            if (h < 1 && m < 1)
                return "now"
            if (h < 1)
                return m + "m"
            return h + "h"
        }

        required property Notification notification
        readonly property string summary: notification.summary
        readonly property string body: notification.body
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string image: notification.image
        readonly property int urgency: notification.urgency
        readonly property list<NotificationAction> actions: notification.actions

        function dismiss() {
            notif.popup = false
            const idx = root.list.indexOf(notif)
            if (idx >= 0) {
                root.list.splice(idx, 1)
            }
        }

        readonly property Timer timer: Timer {
            running: true
            interval: notif.notification.expireTimeout > 0 ? notif.notification.expireTimeout : 5000
            onTriggered: {
                notif.popup = false
            }
        }

        readonly property Connections conn: Connections {
            target: notif.notification.Retainable

            function onDropped(): void {
                const idx = root.list.indexOf(notif)
                if (idx >= 0) {
                    root.list.splice(idx, 1)
                }
            }

            function onAboutToDestroy(): void {
                notif.destroy()
            }
        }
    }

    Component {
        id: notifComp

        Notif {}
    }
}
