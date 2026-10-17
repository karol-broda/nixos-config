pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: root

    property var rects: []

    property rect aperture: Qt.rect(0, 0, width, height)
    property real apertureRadius: 24
    property real panelRadius: 24

    property real clipTop: 0

    property bool frameVisible: true

    property color fillColor: "#292c3c"
    property color shadowColor: Qt.rgba(0.137, 0.149, 0.204, 0.55)
    property real shadowSize: 18
    property real shadowOffset: 3
    property real frameShadow: 0.45

    readonly property int maxRects: 16

    readonly property var _rects: (rects ?? []).filter(r => r.w > 0.5 && r.h > 0.5)

    on_RectsChanged: {
        if (_rects.length > maxRects) console.warn("[Outline] more than", maxRects, "surfaces; extra ones are not drawn")
    }

    readonly property rect _bounds: {
        if (_rects.length === 0) return Qt.rect(0, 0, 0, 0)
        const margin = Math.max(panelRadius, apertureRadius) * 3 + shadowSize + Math.abs(shadowOffset) + 2
        const left = Math.max(0, Math.floor(Math.min(..._rects.map(r => r.x)) - margin))
        const top = Math.max(0, Math.floor(Math.min(..._rects.map(r => r.y)) - margin))
        const right = Math.min(width, Math.ceil(Math.max(..._rects.map(r => r.x + r.w)) + margin))
        const bottom = Math.min(height, Math.ceil(Math.max(..._rects.map(r => r.y + r.h)) + margin))
        return Qt.rect(left, top, right - left, bottom - top)
    }

    Repeater {
        model: 2

        ShaderEffect {
            id: pass

            required property int index
            readonly property bool isFrame: pass.index === 0
            readonly property var list: pass.isFrame ? [] : root._rects

            x: pass.isFrame ? 0 : root._bounds.x
            y: pass.isFrame ? 0 : root._bounds.y
            width: pass.isFrame ? root.width : root._bounds.width
            height: pass.isFrame ? root.height : root._bounds.height
            visible: pass.isFrame ? root.frameVisible : root._rects.length > 0

            readonly property int mode: pass.isFrame ? 0 : (root.frameVisible ? 1 : 2)
            readonly property vector4d bounds: Qt.vector4d(pass.x, pass.y, pass.width, pass.height)
            readonly property vector4d hole: pass.isFrame && root._rects.length > 0
                ? Qt.vector4d(root._bounds.x, root._bounds.y, root._bounds.width, root._bounds.height)
                : Qt.vector4d(0, 0, 0, 0)
            readonly property vector4d aperture: Qt.vector4d(root.aperture.x, root.aperture.y, root.aperture.width, root.aperture.height)
            readonly property real apertureRadius: root.apertureRadius
            readonly property real radius: root.panelRadius
            readonly property real clipTop: root.clipTop
            readonly property int count: Math.min(root.maxRects, pass.list.length)
            readonly property color fillColor: root.fillColor
            readonly property color shadowColor: root.shadowColor
            readonly property real shadowSize: root.shadowSize
            readonly property real shadowOffset: root.shadowOffset
            readonly property real frameShadow: root.frameShadow

            function slot(i: int): vector4d {
                const r = pass.list[i]
                return r ? Qt.vector4d(r.x, r.y, r.w, r.h) : Qt.vector4d(0, 0, 0, 0)
            }

            readonly property vector4d r0: pass.slot(0)
            readonly property vector4d r1: pass.slot(1)
            readonly property vector4d r2: pass.slot(2)
            readonly property vector4d r3: pass.slot(3)
            readonly property vector4d r4: pass.slot(4)
            readonly property vector4d r5: pass.slot(5)
            readonly property vector4d r6: pass.slot(6)
            readonly property vector4d r7: pass.slot(7)
            readonly property vector4d r8: pass.slot(8)
            readonly property vector4d r9: pass.slot(9)
            readonly property vector4d r10: pass.slot(10)
            readonly property vector4d r11: pass.slot(11)
            readonly property vector4d r12: pass.slot(12)
            readonly property vector4d r13: pass.slot(13)
            readonly property vector4d r14: pass.slot(14)
            readonly property vector4d r15: pass.slot(15)

            fragmentShader: Qt.resolvedUrl("../assets/shaders/outline.frag.qsb")
        }
    }
}
