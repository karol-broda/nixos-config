import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import qs.theme
import "PanelOutline.mjs" as Outline

Item {
    id: root

    // list of {x, y, w, h} rect objects describing panel geometries
    property var panels: []

    // frame edge positions (set to the coordinate where panels meet the frame, null to disable)
    property var frameTop: null
    property var frameLeft: null
    property var frameRight: null
    property var frameBottom: null

    // maximum gap between panels that will be bridged into one shape
    property real gapThreshold: 20

    property color fillColor: Colors.frameBg

    readonly property var _activeRects: {
        const result = []
        if (root.panels === null || root.panels === undefined) return result

        for (let i = 0; i < root.panels.length; i++) {
            const p = root.panels[i]
            if (p === null || p === undefined) continue
            if (p.w > 0 && p.h > 0) {
                result.push({ x: p.x, y: p.y, w: p.w, h: p.h })
            }
        }
        return result
    }

    readonly property var _pathData: {
        if (_activeRects.length === 0) return []
        return Outline.outlinePath(_activeRects, {
            r: Spacing.panelRadius,
            k: Spacing.panelCurvature,
            gapThreshold: root.gapThreshold,
            frameTop: root.frameTop,
            frameLeft: root.frameLeft,
            frameRight: root.frameRight,
            frameBottom: root.frameBottom
        })
    }

    readonly property string _svgPath: Outline.toSvgString(root._pathData)
    readonly property bool _hasContent: _pathData.length > 0

    // --- ghost cross-fade for topology transitions ---
    property string _ghostSvgPath: ""
    property string _prevSvgPath: ""
    property int _prevSubpathCount: 0

    on_SvgPathChanged: {
        const newCount = _pathData.length

        // trigger ghost when topology changes (split/merge) while content exists
        if (_prevSubpathCount > 0 && newCount > 0 && newCount !== _prevSubpathCount && _prevSvgPath !== "") {
            _ghostSvgPath = _prevSvgPath
            ghostShape.opacity = 1
        }

        _prevSvgPath = _svgPath
        _prevSubpathCount = newCount
    }

    anchors.fill: parent

    // smooth fade instead of hard visibility toggle
    opacity: _hasContent ? 1 : 0
    visible: opacity > 0.01

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Motion.curveEnter
        }
    }

    // ghost: previous outline that fades out during topology transitions
    Shape {
        id: ghostShape

        anchors.fill: parent
        opacity: 0
        visible: opacity > 0.01
        preferredRendererType: Shape.CurveRenderer

        Behavior on opacity {
            NumberAnimation {
                duration: Motion.panelOpenDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Motion.curveExit
            }
        }

        ShapePath {
            strokeWidth: -1
            fillColor: root.fillColor

            PathSvg {
                path: root._ghostSvgPath
            }
        }
    }

    // active outline with drop shadow
    Shape {
        id: outlineShape

        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        layer.enabled: root._hasContent
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Colors.withAlpha(Colors.crust, 0.4)
            shadowBlur: 0.3
            shadowVerticalOffset: 4
            shadowHorizontalOffset: 0
        }

        ShapePath {
            strokeWidth: -1
            fillColor: root.fillColor

            PathSvg {
                path: root._svgPath
            }
        }
    }
}
