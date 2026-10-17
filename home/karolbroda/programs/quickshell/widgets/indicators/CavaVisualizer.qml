import QtQuick
import qs.core
import qs.theme
import qs.services

Item {
    id: root

    property color colorStart: Colors.accent
    property color colorEnd: Colors.accentAlt
    property real amplitude: 1.2
    property bool showDots: false
    property real dotRadius: 4

    readonly property list<real> cavaValues: Cava.values

    property bool active: true

    Lease {
        target: Cava
        active: root.active && root.visible
    }

    onCavaValuesChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    function colorAt(t: real): color {
        const c = Math.max(0, Math.min(1, t))
        return Qt.rgba(
            colorStart.r + (colorEnd.r - colorStart.r) * c,
            colorStart.g + (colorEnd.g - colorStart.g) * c,
            colorStart.b + (colorEnd.b - colorStart.b) * c,
            1
        )
    }

    function toRgba(color: color, alpha: real): string {
        return "rgba("
            + Math.round(color.r * 255) + ","
            + Math.round(color.g * 255) + ","
            + Math.round(color.b * 255) + ","
            + alpha + ")"
    }

    function sampleBand(bandStart: real, bandEnd: real, count: int): list<real> {
        const vals = root.cavaValues
        if (vals.length === 0) {
            const empty = []
            for (let e = 0; e < count; e++) empty.push(0)
            return empty
        }

        const len = vals.length
        const result = []
        for (let i = 0; i < count; i++) {
            const frac = count > 1 ? i / (count - 1) : 0.5
            const idx = Math.round(bandStart + (bandEnd - bandStart) * frac)
            const safeIdx = Math.max(0, Math.min(len - 1, idx))
            const raw = vals[safeIdx] / 100
            result.push(raw > 0 ? Math.pow(raw, 0.5) * root.amplitude : 0)
        }
        return result
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            const ctx = getContext("2d")
            if (!ctx) return
            ctx.clearRect(0, 0, width, height)

            const w = width
            const h = height
            if (w <= 0 || h <= 0) return

            const cy = h / 2
            const maxH = cy * 0.88

            const bass = root.sampleBand(0, 10, 6)
            const mid = root.sampleBand(8, 22, 8)
            const treble = root.sampleBand(18, 31, 10)

            drawRibbon(ctx, w, cy, maxH, bass, root.colorAt(0), 0.4)
            drawRibbon(ctx, w, cy, maxH * 0.65, mid, root.colorAt(0.5), 0.3)
            drawRibbon(ctx, w, cy, maxH * 0.4, treble, root.colorAt(1.0), 0.25)

            if (root.showDots) {
                drawDot(ctx, root.dotRadius, cy, root.dotRadius, root.colorStart)
                drawDot(ctx, w - root.dotRadius, cy, root.dotRadius, root.colorEnd)
            }
        }

        function drawDot(ctx: var, x: real, y: real, r: real, color: color): void {
            ctx.beginPath()
            ctx.arc(x, y, r, 0, Math.PI * 2)
            ctx.fillStyle = root.toRgba(color, 0.8)
            ctx.fill()
        }

        function drawRibbon(ctx: var, w: real, cy: real, maxH: real, samples: list<real>, color: color, opacity: real): void {
            const n = samples.length
            if (n < 2) return

            const pts = []
            for (let i = 0; i < n; i++) {
                const val = Math.min(samples[i], 1.0)
                pts.push({
                    x: w * i / (n - 1),
                    d: val * maxH
                })
            }

            ctx.beginPath()
            ctx.moveTo(pts[0].x, cy - pts[0].d)

            smoothEdge(ctx, pts, cy, -1)

            ctx.lineTo(pts[n - 1].x, cy + pts[n - 1].d)

            smoothEdgeReverse(ctx, pts, cy, 1)

            ctx.closePath()
            ctx.fillStyle = root.toRgba(color, opacity)
            ctx.fill()
        }

        function smoothEdge(ctx: var, pts: var, cy: real, sign: real): void {
            for (let i = 0; i < pts.length - 1; i++) {
                const p0 = pts[Math.max(0, i - 1)]
                const p1 = pts[i]
                const p2 = pts[i + 1]
                const p3 = pts[Math.min(pts.length - 1, i + 2)]

                const y0 = cy + sign * p0.d
                const y1 = cy + sign * p1.d
                const y2 = cy + sign * p2.d
                const y3 = cy + sign * p3.d

                ctx.bezierCurveTo(
                    p1.x + (p2.x - p0.x) / 6,
                    y1 + (y2 - y0) / 6,
                    p2.x - (p3.x - p1.x) / 6,
                    y2 - (y3 - y1) / 6,
                    p2.x,
                    y2
                )
            }
        }

        function smoothEdgeReverse(ctx: var, pts: var, cy: real, sign: real): void {
            for (let i = pts.length - 1; i > 0; i--) {
                const p0 = pts[Math.min(pts.length - 1, i + 1)]
                const p1 = pts[i]
                const p2 = pts[i - 1]
                const p3 = pts[Math.max(0, i - 2)]

                const y0 = cy + sign * p0.d
                const y1 = cy + sign * p1.d
                const y2 = cy + sign * p2.d
                const y3 = cy + sign * p3.d

                ctx.bezierCurveTo(
                    p1.x + (p2.x - p0.x) / 6,
                    y1 + (y2 - y0) / 6,
                    p2.x - (p3.x - p1.x) / 6,
                    y2 - (y3 - y1) / 6,
                    p2.x,
                    y2
                )
            }
        }
    }
}
