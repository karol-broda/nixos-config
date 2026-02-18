import QtQuick
import QtQuick.Shapes
import qs.theme
import "PanelPath.mjs" as PanelPath

Item {
    id: root

    // which edge/corner to slide from:
    // edges: "left", "right", "top", "bottom"
    // corners: "top-left", "top-right", "bottom-left", "bottom-right"
    property string edge: "left"

    property bool open: false

    property int contentWidth: 300
    property int contentHeight: 400

    property bool showBackground: false

    default property alias content: contentContainer.data

    readonly property bool isCorner: edge.indexOf("-") !== -1
    readonly property bool isHorizontal: edge === "left" || edge === "right"
    readonly property bool isVertical: edge === "top" || edge === "bottom"

    // map edge string to PanelPath bitflags
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

    // body size shrunk so ears fit within contentWidth x contentHeight
    readonly property real _pathWidth: {
        const r = Spacing.frameInnerRadius;
        if (isVertical) return contentWidth - r * 2;
        if (isCorner) return contentWidth - r;
        return contentWidth;
    }
    readonly property real _pathHeight: {
        const r = Spacing.frameInnerRadius;
        if (isHorizontal) return contentHeight - r * 2;
        if (isCorner) return contentHeight - r;
        return contentHeight;
    }

    visible: isCorner ? (width > 0 && height > 0) : (isHorizontal ? width > 0 : height > 0)
    clip: true

    // initial state: corners animate both, edges animate one dimension
    implicitWidth: isCorner ? 0 : (isHorizontal ? 0 : contentWidth)
    implicitHeight: isCorner ? 0 : (isVertical ? 0 : contentHeight)

    states: State {
        name: "open"
        when: root.open

        PropertyChanges {
            target: root
            implicitWidth: root.contentWidth
            implicitHeight: root.contentHeight
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "open"

            ParallelAnimation {
                NumberAnimation {
                    target: root
                    property: "implicitWidth"
                    duration: Motion.panelDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.curveSlide
                }
                NumberAnimation {
                    target: root
                    property: "implicitHeight"
                    duration: Motion.panelDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.curveSlide
                }
            }
        },
        Transition {
            from: "open"
            to: ""

            ParallelAnimation {
                NumberAnimation {
                    target: root
                    property: "implicitWidth"
                    duration: Motion.panelDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.curveExit
                }
                NumberAnimation {
                    target: root
                    property: "implicitHeight"
                    duration: Motion.panelDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.curveExit
                }
            }
        }
    ]

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

        // ears fit exactly within contentContainer after inset calculation
        anchors.fill: contentContainer
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

    // content container with fixed size, anchored to the slide edge/corner
    Item {
        id: contentContainer

        width: root.contentWidth
        height: root.contentHeight

        anchors.left: (root.edge === "left" || root.edge === "top-left" || root.edge === "bottom-left") ? parent.left : undefined
        anchors.right: (root.edge === "right" || root.edge === "top-right" || root.edge === "bottom-right") ? parent.right : undefined
        anchors.top: (root.edge === "top" || root.edge === "top-left" || root.edge === "top-right") ? parent.top : undefined
        anchors.bottom: (root.edge === "bottom" || root.edge === "bottom-left" || root.edge === "bottom-right") ? parent.bottom : undefined

        // center on the non-anchored axis for edge-only panels
        anchors.verticalCenter: root.isHorizontal ? parent.verticalCenter : undefined
        anchors.horizontalCenter: root.isVertical ? parent.horizontalCenter : undefined
    }
}
