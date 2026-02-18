import QtQuick
import qs.theme
import qs.services

Item {
    id: root

    property color colorStart: Colors.accent
    property color colorEnd: Colors.accentAlt
    property real amplitude: 1.2
    property bool showDots: false
    property real dotRadius: 4

    readonly property var cavaValues: Cava.values

    Component.onCompleted: Cava.refCount++
    Component.onDestruction: Cava.refCount--

    onCavaValuesChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    function colorAt(t) {
        var c = Math.max(0, Math.min(1, t));
        return Qt.rgba(
            colorStart.r + (colorEnd.r - colorStart.r) * c,
            colorStart.g + (colorEnd.g - colorStart.g) * c,
            colorStart.b + (colorEnd.b - colorStart.b) * c,
            1
        );
    }

    function toRgba(color, alpha) {
        return "rgba("
            + Math.round(color.r * 255) + ","
            + Math.round(color.g * 255) + ","
            + Math.round(color.b * 255) + ","
            + alpha + ")";
    }

    function sampleBand(bandStart, bandEnd, count) {
        var vals = root.cavaValues;
        if (vals === null || vals === undefined || vals.length === 0) {
            var empty = [];
            for (var e = 0; e < count; e++) empty.push(0);
            return empty;
        }

        var len = vals.length;
        var result = [];
        for (var i = 0; i < count; i++) {
            var frac = count > 1 ? i / (count - 1) : 0.5;
            var idx = Math.round(bandStart + (bandEnd - bandStart) * frac);
            var safeIdx = Math.max(0, Math.min(len - 1, idx));
            var raw = vals[safeIdx] / 100;
            result.push(raw > 0 ? Math.pow(raw, 0.5) * root.amplitude : 0);
        }
        return result;
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d");
            if (ctx === null || ctx === undefined) return;
            ctx.clearRect(0, 0, width, height);

            var w = width;
            var h = height;
            if (w <= 0 || h <= 0) return;

            var cy = h / 2;
            var maxH = cy * 0.88;

            var bass = root.sampleBand(0, 10, 6);
            var mid = root.sampleBand(8, 22, 8);
            var treble = root.sampleBand(18, 31, 10);

            drawRibbon(ctx, w, cy, maxH, bass, root.colorAt(0), 0.4);
            drawRibbon(ctx, w, cy, maxH * 0.65, mid, root.colorAt(0.5), 0.3);
            drawRibbon(ctx, w, cy, maxH * 0.4, treble, root.colorAt(1.0), 0.25);

            if (root.showDots) {
                drawDot(ctx, root.dotRadius, cy, root.dotRadius, root.colorStart);
                drawDot(ctx, w - root.dotRadius, cy, root.dotRadius, root.colorEnd);
            }
        }

        function drawDot(ctx, x, y, r, color) {
            ctx.beginPath();
            ctx.arc(x, y, r, 0, Math.PI * 2);
            ctx.fillStyle = root.toRgba(color, 0.8);
            ctx.fill();
        }

        function drawRibbon(ctx, w, cy, maxH, samples, color, opacity) {
            var n = samples.length;
            if (n < 2) return;

            var pts = [];
            for (var i = 0; i < n; i++) {
                var val = Math.min(samples[i], 1.0);
                pts.push({
                    x: w * i / (n - 1),
                    d: val * maxH
                });
            }

            ctx.beginPath();
            ctx.moveTo(pts[0].x, cy - pts[0].d);

            smoothEdge(ctx, pts, cy, -1);

            ctx.lineTo(pts[n - 1].x, cy + pts[n - 1].d);

            smoothEdgeReverse(ctx, pts, cy, 1);

            ctx.closePath();
            ctx.fillStyle = root.toRgba(color, opacity);
            ctx.fill();
        }

        function smoothEdge(ctx, pts, cy, sign) {
            for (var i = 0; i < pts.length - 1; i++) {
                var p0 = pts[Math.max(0, i - 1)];
                var p1 = pts[i];
                var p2 = pts[i + 1];
                var p3 = pts[Math.min(pts.length - 1, i + 2)];

                var y0 = cy + sign * p0.d;
                var y1 = cy + sign * p1.d;
                var y2 = cy + sign * p2.d;
                var y3 = cy + sign * p3.d;

                ctx.bezierCurveTo(
                    p1.x + (p2.x - p0.x) / 6,
                    y1 + (y2 - y0) / 6,
                    p2.x - (p3.x - p1.x) / 6,
                    y2 - (y3 - y1) / 6,
                    p2.x,
                    y2
                );
            }
        }

        function smoothEdgeReverse(ctx, pts, cy, sign) {
            for (var i = pts.length - 1; i > 0; i--) {
                var p0 = pts[Math.min(pts.length - 1, i + 1)];
                var p1 = pts[i];
                var p2 = pts[i - 1];
                var p3 = pts[Math.max(0, i - 2)];

                var y0 = cy + sign * p0.d;
                var y1 = cy + sign * p1.d;
                var y2 = cy + sign * p2.d;
                var y3 = cy + sign * p3.d;

                ctx.bezierCurveTo(
                    p1.x + (p2.x - p0.x) / 6,
                    y1 + (y2 - y0) / 6,
                    p2.x - (p3.x - p1.x) / 6,
                    y2 - (y3 - y1) / 6,
                    p2.x,
                    y2
                );
            }
        }
    }
}
