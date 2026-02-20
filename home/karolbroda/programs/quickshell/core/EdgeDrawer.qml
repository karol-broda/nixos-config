import QtQuick
import QtQuick.Shapes
import qs.theme
import "PanelPath.mjs" as PanelPath

Panel {
    id: root

    property string edge: "left"
    property int contentWidth: 300
    property int contentHeight: 400
    property bool showBackground: false

    slideFrom: edge
    targetWidth: contentWidth
    targetHeight: contentHeight
    contentFade: false

    visible: _isCorner ? (width > 0 && height > 0) : (_isHorizontal ? width > 0 : height > 0)

    readonly property int _edgeFlags: {
        if (edge === "top") return 1
        if (edge === "right") return 2
        if (edge === "bottom") return 4
        if (edge === "left") return 8
        if (edge === "top-left") return 1 | 8
        if (edge === "top-right") return 1 | 2
        if (edge === "bottom-left") return 4 | 8
        if (edge === "bottom-right") return 4 | 2
        return 0
    }

    readonly property real _pathWidth: {
        const r = Spacing.frameInnerRadius;
        if (_isVertical) return contentWidth - r * 2;
        if (_isCorner) return contentWidth - r;
        return contentWidth;
    }
    readonly property real _pathHeight: {
        const r = Spacing.frameInnerRadius;
        if (_isHorizontal) return contentHeight - r * 2;
        if (_isCorner) return contentHeight - r;
        return contentHeight;
    }

    Shape {
        id: bgShape

        readonly property var pathData: {
            const w = root._pathWidth;
            const h = root._pathHeight;
            if (w <= 0 || h <= 0) return [];
            return PanelPath.generatePath(
                w, h,
                Spacing.frameInnerRadius,
                Spacing.panelCurvature,
                root._edgeFlags
            );
        }

        anchors.fill: parent
        visible: root.showBackground && pathData.length > 0
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: -1
            fillColor: bgShape.visible ? Colors.frameBg : "transparent"

            PathSvg {
                path: PanelPath.toSvgString(bgShape.pathData)
            }
        }
    }
}
