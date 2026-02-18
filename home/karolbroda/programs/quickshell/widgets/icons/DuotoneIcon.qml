import QtQuick
import QtQuick.Effects
import qs.theme

Item {
    id: root

    property string name: ""
    property int size: Spacing.iconMd
    property string iconState: "default"  // default, hover, active, disabled

    property color color: {
        switch (iconState) {
            case "hover": return Colors.iconHoverPrimary
            case "active": return Colors.iconActivePrimary
            case "disabled": return Colors.iconDisabledPrimary
            default: return Colors.iconPrimary
        }
    }

    implicitWidth: size
    implicitHeight: size
    width: size
    height: size

    Image {
        id: iconImage
        anchors.fill: parent
        sourceSize.width: root.size * 2
        sourceSize.height: root.size * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        asynchronous: false
        visible: false

        source: {
            if (root.name === null || root.name === undefined || root.name === "") {
                return ""
            }
            const basePath = Qt.resolvedUrl("../../assets/phosphor-icons/duotone")
            return basePath + "/" + root.name + "-duotone.svg"
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: iconImage
        brightness: 1.0
        colorization: 1.0
        colorizationColor: root.color
        visible: iconImage.status === Image.Ready
    }

    Image {
        id: fallbackImage
        anchors.fill: parent
        sourceSize.width: root.size * 2
        sourceSize.height: root.size * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        asynchronous: false
        visible: false

        source: {
            if (root.name === null || root.name === undefined || root.name === "") {
                return ""
            }
            const basePath = Qt.resolvedUrl("../../assets/phosphor-icons/regular")
            return basePath + "/" + root.name + ".svg"
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: fallbackImage
        brightness: 1.0
        colorization: 1.0
        colorizationColor: root.color
        visible: iconImage.status !== Image.Ready && fallbackImage.status === Image.Ready
    }

    Rectangle {
        anchors.centerIn: parent
        width: root.size * 0.7
        height: root.size * 0.7
        radius: Spacing.radiusSm
        color: "transparent"
        border.width: 1
        border.color: Colors.textDim
        visible: iconImage.status !== Image.Ready && fallbackImage.status !== Image.Ready

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
