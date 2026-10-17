pragma ComponentBehavior: Bound

import QtQuick
import qs.theme

Item {
    id: root

    property var results: []
    property int selectedIndex: 0

    signal itemClicked(int index)
    signal itemHovered(int index)

    implicitHeight: listView.contentHeight

    onSelectedIndexChanged: listView.positionViewAtIndex(selectedIndex, ListView.Contain)

    ListView {
        id: listView

        anchors.fill: parent
        model: root.results
        spacing: Spacing.spacingXs
        clip: true
        interactive: contentHeight > height

        delegate: ResultItem {
            required property var modelData
            required property int index

            width: listView.width
            result: modelData
            isSelected: root.selectedIndex === index

            onClicked: root.itemClicked(index)
            onHovered: root.itemHovered(index)
        }
    }
}
