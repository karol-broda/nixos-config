pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property color rosewater: "#f2d5cf"
    readonly property color flamingo: "#eebebe"
    readonly property color pink: "#f4b8e4"
    readonly property color mauve: "#ca9ee6"
    readonly property color red: "#e78284"
    readonly property color maroon: "#ea999c"
    readonly property color peach: "#ef9f76"
    readonly property color yellow: "#e5c890"
    readonly property color green: "#a6d189"
    readonly property color teal: "#81c8be"
    readonly property color sky: "#99d1db"
    readonly property color sapphire: "#85c1dc"
    readonly property color blue: "#8caaee"
    readonly property color lavender: "#babbf1"

    readonly property color text: "#c6d0f5"
    readonly property color subtext1: "#b5bfe2"
    readonly property color subtext0: "#a5adce"
    readonly property color overlay2: "#949cbb"
    readonly property color overlay1: "#838ba7"
    readonly property color overlay0: "#737994"
    readonly property color surface2: "#626880"
    readonly property color surface1: "#51576d"
    readonly property color surface0: "#414559"
    readonly property color base: "#303446"
    readonly property color mantle: "#292c3c"
    readonly property color crust: "#232634"

    readonly property color accent: lavender
    readonly property color accentAlt: mauve

    readonly property color textPrimary: text
    readonly property color textSecondary: subtext1
    readonly property color textMuted: subtext0
    readonly property color textDim: overlay1

    readonly property color bgPrimary: base
    readonly property color bgSecondary: mantle
    readonly property color bgTertiary: crust
    readonly property color bgElevated: surface0
    readonly property color bgHover: surface1
    readonly property color bgActive: surface2

    readonly property color border: surface1
    readonly property color borderSubtle: surface0
    readonly property color divider: surface0

    readonly property color success: green
    readonly property color warning: yellow
    readonly property color error: red
    readonly property color info: blue

    readonly property color barBg: mantle
    readonly property color barPill: surface0
    readonly property color barPillHover: surface1

    readonly property color panelBg: base
    readonly property color panelBorder: surface0

    readonly property color frameBg: mantle
    readonly property color frameBorder: surface0

    readonly property color iconPrimary: subtext0
    readonly property color iconSecondary: surface2
    readonly property color iconHoverPrimary: text
    readonly property color iconHoverSecondary: overlay1
    readonly property color iconActivePrimary: lavender
    readonly property color iconActiveSecondary: mauve
    readonly property color iconDisabledPrimary: overlay0
    readonly property color iconDisabledSecondary: surface1

    function withAlpha(color, alpha) {
        if (color === null || color === undefined) {
            return Qt.rgba(0, 0, 0, alpha)
        }
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }
}
