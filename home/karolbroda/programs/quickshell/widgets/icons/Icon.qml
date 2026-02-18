import QtQuick
import QtQuick.Effects
import qs.theme

Item {
    id: root

    property string name: ""
    property int size: Spacing.iconMd
    property string weight: "regular"  // regular, bold, light, thin, fill, duotone
    property color color: Colors.iconPrimary
    property bool filled: false

    readonly property string effectiveWeight: filled ? "fill" : weight

    readonly property string iconFileName: {
        if (effectiveWeight === "regular") {
            return name + ".svg"
        }
        return name + "-" + effectiveWeight + ".svg"
    }

    readonly property string iconSource: {
        if (name === null || name === undefined || name === "") {
            return ""
        }
        const basePath = Qt.resolvedUrl("../../assets/phosphor-icons")
        return basePath + "/" + effectiveWeight + "/" + iconFileName
    }

    implicitWidth: size
    implicitHeight: size
    width: size
    height: size

    Image {
        id: iconImage
        anchors.fill: parent
        source: root.iconSource
        sourceSize.width: root.size * 2
        sourceSize.height: root.size * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        asynchronous: false
        visible: false
    }

    MultiEffect {
        anchors.fill: parent
        source: iconImage
        brightness: 1.0
        colorization: 1.0
        colorizationColor: root.color
        visible: iconImage.status === Image.Ready
    }

    Rectangle {
        anchors.centerIn: parent
        width: root.size * 0.7
        height: root.size * 0.7
        radius: Spacing.radiusSm
        color: "transparent"
        border.width: 1
        border.color: Colors.textDim
        visible: iconImage.status === Image.Error || iconImage.status === Image.Null

        Text {
            anchors.centerIn: parent
            text: "?"
            font.pixelSize: root.size * 0.4
            font.family: Typography.bodyFamily
            color: Colors.textDim
        }
    }

    Behavior on color {
        ColorAnimation { duration: Motion.hoverDuration }
    }
}
