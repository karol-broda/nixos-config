import QtQuick
import QtQuick.Shapes
import qs.theme
import "PanelOutline.mjs" as Outline

Shape {
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

    // shape fills the parent; path coordinates are in parent's coordinate space
    anchors.fill: parent
    visible: _pathData.length > 0

    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeWidth: -1
        fillColor: root.visible ? root.fillColor : "transparent"

        PathSvg {
            path: Outline.toSvgString(root._pathData)
        }
    }
}
