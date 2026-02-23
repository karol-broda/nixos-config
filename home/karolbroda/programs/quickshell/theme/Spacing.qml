pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24
    readonly property int spacing2xl: 32

    readonly property int paddingXs: 4
    readonly property int paddingSm: 8
    readonly property int paddingMd: 12
    readonly property int paddingLg: 16
    readonly property int paddingXl: 20

    readonly property int radiusXs: 4
    readonly property int radiusSm: 6
    readonly property int radiusMd: 8
    readonly property int radiusLg: 12
    readonly property int radiusXl: 16
    readonly property int radiusFull: 9999

    readonly property int iconXs: 12
    readonly property int iconSm: 16
    readonly property int iconMd: 20
    readonly property int iconLg: 24
    readonly property int iconXl: 32
    readonly property int icon2xl: 48

    readonly property int barHeight: 40
    readonly property int barPadding: 8
    readonly property int barItemSpacing: 8
    readonly property int barRadius: 0

    readonly property int panelPadding: 16
    readonly property int panelRadius: 16
    readonly property int panelMaxWidth: 380
    readonly property int panelMaxHeight: 560
    readonly property int panelGap: 8

    readonly property int frameWidth: 6
    readonly property int frameRadius: 12
    readonly property int frameInnerRadius: 12

    readonly property real panelCurvature: 0.552

    // computed insets from screen edges to the panel content area
    readonly property int panelTopInset: barHeight + frameWidth
    readonly property int panelSideInset: frameWidth
}
