pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // families
    readonly property string displayFamily: "EB Garamond"
    readonly property string bodyFamily: "Lato"
    readonly property string monoFamily: "MonaspiceAr Nerd Font"

    // weights
    readonly property int weightLight: Font.Light
    readonly property int weightRegular: Font.Normal
    readonly property int weightMedium: Font.Medium
    readonly property int weightSemiBold: Font.DemiBold
    readonly property int weightBold: Font.Bold

    // type scale
    readonly property int sizeDisplay: 32
    readonly property int sizeTitle: 22
    readonly property int sizeHeading: 16
    readonly property int sizeBody: 14
    readonly property int sizeLabel: 12
    readonly property int sizeCaption: 11
    readonly property int sizeMicro: 10

    // letter spacing
    readonly property real letterSpacingTight: -0.5
    readonly property real letterSpacingNormal: 0
    readonly property real letterSpacingWide: 0.5
    readonly property real letterSpacingExtraWide: 1.0

    // title: panel headers like "Dashboard", "Notifications"
    readonly property string titleFamily: displayFamily
    readonly property int titleSize: sizeTitle
    readonly property int titleWeight: weightLight
    readonly property real titleSpacing: letterSpacingTight

    // heading: content headers, notification summaries
    readonly property string headingFamily: displayFamily
    readonly property int headingSize: sizeHeading
    readonly property int headingWeight: weightRegular

    // body: main content text
    readonly property string bodyTextFamily: bodyFamily
    readonly property int bodyTextSize: sizeBody
    readonly property int bodyTextWeight: weightRegular

    // label: metadata, secondary info, small descriptions
    readonly property string labelFamily: bodyFamily
    readonly property int labelSize: sizeLabel
    readonly property int labelWeight: weightRegular
    readonly property real labelSpacing: letterSpacingWide

    // mono: data values, percentages, technical readouts
    readonly property string monoTextFamily: monoFamily
    readonly property int monoTextSize: sizeBody
    readonly property int monoTextWeight: weightLight

    // bar clock
    readonly property string barClockFamily: displayFamily
    readonly property int barClockSize: 20
    readonly property int barClockWeight: weightLight
    readonly property real barClockSpacing: letterSpacingTight

    // input text
    readonly property string inputFamily: bodyFamily
    readonly property int inputSize: sizeBody
    readonly property real inputSpacing: letterSpacingWide

    // placeholder text (serif italic in inputs and empty states)
    readonly property string placeholderFamily: displayFamily
    readonly property int placeholderSize: sizeBody
    readonly property int placeholderWeight: weightLight
    readonly property real placeholderSpacing: letterSpacingWide

    // lockscreen clock
    readonly property int lockClockSize: 140
    readonly property int lockClockWeight: weightLight
    readonly property real lockClockSpacing: -4

    // lockscreen date
    readonly property int lockDateSize: 18
    readonly property int lockDateWeight: weightLight
    readonly property real lockDateSpacing: letterSpacingExtraWide

    // lockscreen hints
    readonly property int lockHintSize: 13

    // osd status text (battery charging, etc.)
    readonly property string osdStatusFamily: displayFamily
    readonly property int osdStatusSize: sizeBody
    readonly property int osdStatusWeight: weightRegular
    readonly property real osdStatusSpacing: letterSpacingWide

    // micro labels (toggle buttons, provider pills)
    readonly property real microLabelSpacing: letterSpacingExtraWide
}
