import QtQuick
import qs.theme

Item {
    id: root

    property var results: []
    property int selectedIndex: 0

    signal itemClicked(int index)
    signal itemHovered(int index)

    implicitHeight: listView.contentHeight

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

        onCurrentIndexChanged: {
            listView.positionViewAtIndex(root.selectedIndex, ListView.Contain)
        }

        Binding {
            target: listView
            property: "currentIndex"
            value: root.selectedIndex
        }
    }
}
