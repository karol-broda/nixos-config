pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import qs.core
import qs.theme
import qs.services

Item {
    id: root

    readonly property list<real> cavaValues: Cava.values
    property int segments: 10
    property real curveSpill: 2.0

    property bool active: true

    Lease {
        target: Cava
        active: root.active && root.visible
    }

    function audioFor(index: int): real {
        const len = root.cavaValues.length
        if (len === 0) return 0

        let mapped = Math.floor(index * len / segments)
        if (mapped < 0) mapped = 0
        if (mapped >= len) mapped = len - 1

        const raw = cavaValues[mapped] / 100
        if (raw <= 0) return 0
        return Math.min(raw * 1.5, 1.0)
    }

    function lerpColor(c1: color, c2: color, t: real): color {
        return Qt.rgba(
            c1.r + (c2.r - c1.r) * t,
            c1.g + (c2.g - c1.g) * t,
            c1.b + (c2.b - c1.b) * t,
            c1.a + (c2.a - c1.a) * t
        )
    }

    function curveColor(index: int): color {
        const t = index / Math.max(1, root.segments - 1)
        let base
        if (t < 0.5) {
            base = lerpColor(Colors.mauve, Colors.lavender, t * 2.0)
        } else {
            base = lerpColor(Colors.lavender, Colors.blue, (t - 0.5) * 2.0)
        }
        if (index % 2 === 0) return Qt.darker(base, 1.4)
        return base
    }

    Shape {
        id: shape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        Instantiator {
            model: root.segments

            delegate: ShapePath {
                id: path

                required property int index
                readonly property real audio: root.audioFor(path.index)

                strokeWidth: 2.5 - 0.5 * path.audio
                strokeColor: root.curveColor(path.index)
                fillColor: "transparent"

                startX: 0
                startY: shape.height / 2

                PathCubic {
                    x: shape.width
                    y: shape.height / 2

                    control1X: {
                        const base = (path.index - 1) / root.segments
                        const dir = (path.index > root.segments / 2) ? 1.0 : -1.0
                        const offset = dir * path.audio * root.curveSpill / root.segments
                        return (base + offset) * shape.width
                    }
                    control1Y: {
                        const dir = (path.index < root.segments / 4 || path.index > root.segments * 3 / 4) ? -1.0 : 1.0
                        return shape.height / 2 + dir * (shape.height / 2) * path.audio
                    }

                    control2X: shape.width
                    control2Y: shape.height / 2
                }
            }

            onObjectAdded: (index, object) => {
                shape.data.push(object)
            }
        }
    }
}
