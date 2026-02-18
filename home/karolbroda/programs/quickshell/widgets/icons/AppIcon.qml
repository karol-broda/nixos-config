import QtQuick
import Quickshell
import qs.theme
import qs.services

Item {
    id: root

    property string appId: ""
    property string iconName: ""
    property string source: ""
    property int size: Spacing.iconLg

    // bumped to force re-evaluation of icon bindings after desktop
    // entries or icon theme finish loading asynchronously
    property int _resolveRevision: 0
    // briefly set true to clear the image source, invalidating
    // any cached load failures before a fresh attempt
    property bool _clearing: false

    function _retryResolve(): void {
        var freshSource = ""
        if (root.appId !== null && root.appId !== undefined && root.appId !== "") {
            freshSource = AppIcons.forApp(root.appId)
        } else if (root.iconName !== null && root.iconName !== undefined && root.iconName !== "") {
            freshSource = AppIcons.forName(root.iconName)
        }

        if (freshSource === root._primarySource) return

        root._sourceIndex = 0
        root._clearing = true
        root._resolveRevision += 1
        _restoreTimer.restart()
    }

    readonly property string _iconSearchName: {
        var _rev = root._resolveRevision
        if (root.appId !== null && root.appId !== undefined && root.appId !== "") {
            return AppIcons.getIconName(root.appId)
        }
        if (root.iconName !== null && root.iconName !== undefined && root.iconName !== "") {
            return root.iconName
        }
        return ""
    }

    readonly property string _primarySource: {
        var _rev = root._resolveRevision
        if (root.source !== null && root.source !== undefined && root.source !== "") {
            return root.source
        }
        if (root.appId !== null && root.appId !== undefined && root.appId !== "") {
            return AppIcons.forApp(root.appId)
        }
        if (root.iconName !== null && root.iconName !== undefined && root.iconName !== "") {
            return AppIcons.forName(root.iconName)
        }
        return ""
    }

    readonly property var _allSources: {
        var list = []
        if (_primarySource !== "") {
            list.push(_primarySource)
        }
        // only add pixmap fallbacks when the source comes from theme lookup
        // (not for direct source pass-through, which is already a concrete path)
        if (root.source === "" || root.source === null || root.source === undefined) {
            var fallbacks = AppIcons.fallbackSources(root._iconSearchName)
            for (var i = 0; i < fallbacks.length; i++) {
                list.push(fallbacks[i])
            }
        }
        return list
    }

    property int _sourceIndex: 0

    onAppIdChanged: _sourceIndex = 0
    onIconNameChanged: _sourceIndex = 0
    onSourceChanged: _sourceIndex = 0

    readonly property string displayName: {
        if (root.appId !== null && root.appId !== undefined && root.appId !== "") {
            return root.appId
        }
        if (root.iconName !== null && root.iconName !== undefined && root.iconName !== "") {
            return root.iconName
        }
        return ""
    }

    readonly property int _requestSize: {
        var target = root.size * 2
        var sizes = [16, 22, 24, 32, 48, 64, 96, 128, 256]
        for (var i = 0; i < sizes.length; i++) {
            if (sizes[i] >= target) {
                return sizes[i]
            }
        }
        return 256
    }

    width: size
    height: size

    Image {
        id: iconImage
        anchors.fill: parent
        sourceSize.width: root._requestSize
        sourceSize.height: root._requestSize
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        asynchronous: true
        visible: status === Image.Ready
        cache: true

        source: {
            if (root._clearing) return ""
            if (root._allSources.length > root._sourceIndex) {
                return root._allSources[root._sourceIndex]
            }
            return ""
        }

        onStatusChanged: {
            if (status === Image.Error) {
                if (root._sourceIndex < root._allSources.length - 1) {
                    root._sourceIndex++
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radiusSm
        color: Colors.surface0
        visible: iconImage.status !== Image.Ready

        Text {
            anchors.centerIn: parent
            text: {
                if (root.displayName === "") {
                    return "?"
                }
                return root.displayName.charAt(0).toUpperCase()
            }
            color: Colors.textSecondary
            font.pixelSize: root.size * 0.5
            font.weight: Typography.weightRegular
            font.family: Typography.displayFamily
        }
    }

    // icon theme and desktop entries load asynchronously, so lookups
    // may resolve to a generic fallback on first load. retry once after
    // a delay so resources have time to become available.
    Timer {
        interval: 2000
        running: (root.appId !== "" || root.iconName !== "") && root._resolveRevision < 1
        repeat: false
        onTriggered: root._retryResolve()
    }

    // restores the image source after a brief clear to flush cached failures
    Timer {
        id: _restoreTimer
        interval: 10
        repeat: false
        onTriggered: root._clearing = false
    }
}
