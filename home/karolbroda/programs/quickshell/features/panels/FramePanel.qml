import QtQuick
import QtQuick.Shapes
import qs.theme
import qs.core
import "../../core/PanelPath.mjs" as PanelPath

Item {
    id: root

    readonly property int edgeTop: 1
    readonly property int edgeRight: 2
    readonly property int edgeBottom: 4
    readonly property int edgeLeft: 8
    readonly property int edgeOutward: 16

    property int edges: 0
    property string panelName: ""
    property bool screenActive: true
    property int panelWidth: 300
    property int panelHeight: 400
    property bool blockInput: true

    property bool isOpen: screenActive && Dispatcher.activePanel === panelName

    default property alias content: contentArea.data

    implicitWidth: drawer.implicitWidth
    implicitHeight: drawer.implicitHeight

    Shape {
        id: bgShape

        readonly property var pathData: {
            const dw = drawer.implicitWidth;
            const dh = drawer.implicitHeight;
            if (dw <= 0 || dh <= 0) return [];
            return PanelPath.generatePath(
                dw, dh,
                Spacing.frameInnerRadius,
                Spacing.panelCurvature,
                root.edges
            );
        }

        readonly property var bounds: pathData.length > 0 ? PanelPath.calculateBounds(pathData) : { x0: 0, y0: 0, x1: 0, y1: 0 }

        x: bounds.x0
        y: bounds.y0
        width: bounds.x1 - bounds.x0
        height: bounds.y1 - bounds.y0

        visible: pathData.length > 0
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: -1
            fillColor: bgShape.visible ? Colors.frameBg : "transparent"

            PathSvg {
                path: PanelPath.toSvgString(bgShape.pathData)
            }
        }
    }

    EdgeDrawer {
        id: drawer
        edge: PanelPath.edgeString(root.edges)
        open: root.isOpen
        contentWidth: root.panelWidth
        contentHeight: root.panelHeight

        MouseArea {
            anchors.fill: parent
            visible: root.blockInput
        }

        Item {
            id: contentArea
            anchors.fill: parent
            anchors.margins: Spacing.panelPadding

            opacity: root.isOpen ? 1 : 0

            property real _revealOffset: root.isOpen ? 0 : 6

            Behavior on _revealOffset {
                NumberAnimation {
                    duration: root.isOpen ? Motion.panelOpenDuration : Motion.panelCloseDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.isOpen ? Motion.curveSlide : Motion.curveExit
                }
            }

            transform: Translate { y: contentArea._revealOffset }

            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation { duration: root.isOpen ? Motion.contentDelay : 0 }
                    NumberAnimation {
                        duration: Motion.durationNormal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Motion.curveEnter
                    }
                }
            }
        }
    }
}
