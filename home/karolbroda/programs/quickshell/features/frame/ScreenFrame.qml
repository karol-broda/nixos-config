import QtQuick
import qs.theme

Item {
    id: root

    property var screen: null
    property int fw: Spacing.frameWidth
    property int topOffset: Spacing.barHeight
    property int ir: Spacing.frameInnerRadius

    anchors.fill: parent

    Rectangle {
        id: topBorder
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: root.topOffset
        height: root.fw
        color: Colors.frameBg
    }

    Rectangle {
        id: bottomBorder
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.fw
        color: Colors.frameBg
    }

    Rectangle {
        id: leftBorder
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: root.topOffset
        width: root.fw
        color: Colors.frameBg
    }

    Rectangle {
        id: rightBorder
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.topMargin: root.topOffset
        width: root.fw
        color: Colors.frameBg
    }

    Canvas {
        id: cornerCanvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var w = width
            var h = height
            var frameWidth = root.fw
            var barHeight = root.topOffset
            var r = root.ir

            var innerLeft = frameWidth
            var innerTop = barHeight + frameWidth
            var innerRight = w - frameWidth
            var innerBottom = h - frameWidth

            ctx.fillStyle = Colors.frameBg.toString()

            ctx.beginPath()
            ctx.moveTo(innerLeft, innerTop)
            ctx.lineTo(innerLeft + r, innerTop)
            ctx.arcTo(innerLeft, innerTop, innerLeft, innerTop + r, r)
            ctx.lineTo(innerLeft, innerTop)
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(innerRight, innerTop)
            ctx.lineTo(innerRight, innerTop + r)
            ctx.arcTo(innerRight, innerTop, innerRight - r, innerTop, r)
            ctx.lineTo(innerRight, innerTop)
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(innerLeft, innerBottom)
            ctx.lineTo(innerLeft, innerBottom - r)
            ctx.arcTo(innerLeft, innerBottom, innerLeft + r, innerBottom, r)
            ctx.lineTo(innerLeft, innerBottom)
            ctx.fill()

            // bottom-right corner fill
            ctx.beginPath()
            ctx.moveTo(innerRight, innerBottom)
            ctx.lineTo(innerRight - r, innerBottom)
            ctx.arcTo(innerRight, innerBottom, innerRight, innerBottom - r, r)
            ctx.lineTo(innerRight, innerBottom)
            ctx.fill()

            // inner edge stroke for depth
            ctx.strokeStyle = Colors.withAlpha(Colors.crust, 0.6).toString()
            ctx.lineWidth = 1

            ctx.beginPath()
            ctx.moveTo(innerLeft + r, innerTop)
            ctx.lineTo(innerRight - r, innerTop)
            ctx.arcTo(innerRight, innerTop, innerRight, innerTop + r, r)
            ctx.lineTo(innerRight, innerBottom - r)
            ctx.arcTo(innerRight, innerBottom, innerRight - r, innerBottom, r)
            ctx.lineTo(innerLeft + r, innerBottom)
            ctx.arcTo(innerLeft, innerBottom, innerLeft, innerBottom - r, r)
            ctx.lineTo(innerLeft, innerTop + r)
            ctx.arcTo(innerLeft, innerTop, innerLeft + r, innerTop, r)
            ctx.stroke()
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    Component.onCompleted: {
        cornerCanvas.requestPaint()
    }
}
