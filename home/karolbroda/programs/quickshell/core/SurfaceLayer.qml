import QtQuick
import qs.theme

Item {
    id: root

    property rect aperture: Qt.rect(0, 0, width, height)
    property real clipTop: 0
    property bool frameVisible: true

    readonly property var surfaces: Array.prototype.filter.call(children, c => c.isSurface === true)

    readonly property var rects: surfaces
        .filter(s => s.visible)
        .map(s => ({ x: s.x, y: s.y, w: s.width, h: s.height }))

    readonly property string _gapViolation: {
        for (let i = 0; i < rects.length; i++) {
            for (let j = i + 1; j < rects.length; j++) {
                const a = rects[i]
                const b = rects[j]
                const gapX = Math.max(b.x - (a.x + a.w), a.x - (b.x + b.w))
                const gapY = Math.max(b.y - (a.y + a.h), a.y - (b.y + b.h))
                const gap = Math.max(gapX, gapY)
                if (gap > 0.5 && gap < Spacing.panelGap) return Math.round(gap) + "px between " + JSON.stringify(a) + " and " + JSON.stringify(b)
            }
            const r = rects[i]
            const sides = [r.x - aperture.x, r.y - aperture.y, aperture.x + aperture.width - (r.x + r.w), aperture.y + aperture.height - (r.y + r.h)]
            const side = sides.find(g => g > 0.5 && g < Spacing.panelGap)
            if (side !== undefined) return Math.round(side) + "px between " + JSON.stringify(r) + " and the frame"
        }
        return ""
    }

    on_GapViolationChanged: {
        if (_gapViolation !== "") console.warn("[SurfaceLayer] surfaces neither touch nor keep panelGap apart:", _gapViolation)
    }

    Outline {
        anchors.fill: parent
        z: -1
        rects: root.rects
        aperture: root.aperture
        clipTop: root.clipTop
        frameVisible: root.frameVisible
        apertureRadius: Spacing.radiusSurface
        panelRadius: Spacing.radiusSurface
        fillColor: Colors.frameBg
        shadowColor: Colors.withAlpha(Colors.crust, 0.55)
    }
}
