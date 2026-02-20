import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.features.panels

Item {
    id: root

    property var screen: null
    property alias inputMaskItem: toastPanel

    property var _tracked: ({})
    property int _toastCount: 0
    property bool _panelOpen: false

    anchors.fill: parent

    // defers panel open by one frame so the toast layout
    // is computed before EdgeDrawer captures its target size
    Timer {
        id: _openDelay
        interval: 0
        onTriggered: root._panelOpen = root._toastCount > 0
    }

    on_ToastCountChanged: {
        if (root._toastCount > 0 && !root._panelOpen) {
            _openDelay.restart()
        } else if (root._toastCount <= 0) {
            root._panelOpen = false
        }
    }

    readonly property var popupSource: Notifs.popups
    onPopupSourceChanged: _sync()
    Component.onCompleted: _sync()

    function _sync() {
        var popups = popupSource
        if (popups === null || popups === undefined) popups = []

        var start = Math.max(0, popups.length - 3)
        for (var i = start; i < popups.length; i++) {
            var p = popups[i]
            if (p === null || p === undefined) continue
            if (root._tracked[p.id] === true) continue

            root._tracked[p.id] = true
            toastComp.createObject(toastColumn, { notification: p })
            root._toastCount++
        }

        _updateDividers()
    }

    function _handleExitDone(toast, fullDismiss) {
        var notif = toast.notification

        // remove from tracking before changing notification state
        // to prevent _sync from re-processing during the change
        if (notif !== null && notif !== undefined) {
            delete root._tracked[notif.id]
        }

        if (fullDismiss
            && notif !== null && notif !== undefined
            && notif.dismiss !== null && notif.dismiss !== undefined
            && typeof notif.dismiss === "function") {
            notif.dismiss()
        } else if (notif !== null && notif !== undefined) {
            notif.popup = false
        }

        root._toastCount = Math.max(0, root._toastCount - 1)
        toast.destroy()
        _updateDividers()
    }

    function _updateDividers() {
        var visibleIdx = 0
        for (var i = 0; i < toastColumn.children.length; i++) {
            var child = toastColumn.children[i]
            if (child === null || child === undefined) continue
            if (child.notification === undefined) continue
            if (child._exiting === true) continue
            child.showDivider = visibleIdx > 0
            visibleIdx++
        }
    }

    Component {
        id: toastComp

        Toast {
            onExitStarted: {
                var remaining = 0
                for (var i = 0; i < toastColumn.children.length; i++) {
                    var child = toastColumn.children[i]
                    if (child === null || child === undefined) continue
                    if (child.notification === undefined) continue
                    if (child._exiting === true) continue
                    remaining++
                }
                if (remaining <= 0) {
                    root._panelOpen = false
                }
            }
            onExitDone: function(fullDismiss) {
                root._handleExitDone(this, fullDismiss)
            }
        }
    }

    FramePanel {
        id: toastPanel

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Spacing.panelTopInset
        anchors.rightMargin: Spacing.panelSideInset

        panelName: ""
        screenActive: true
        edges: edgeTop | edgeRight
        blockInput: false

        isOpen: root._panelOpen
        panelWidth: 360
        panelHeight: toastColumn.implicitHeight + Spacing.panelPadding * 2

        ColumnLayout {
            id: toastColumn
            anchors.fill: parent
            spacing: Spacing.spacingMd
        }
    }
}
