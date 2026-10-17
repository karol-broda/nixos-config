import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets.text
import qs.widgets.inputs
import "sections"

FocusScope {
    id: root

    implicitWidth: 500
    implicitHeight: content.implicitHeight + Spacing.panelPadding * 2

    function focusInput(): void {
        searchField.forceActiveFocus()
    }

    Keys.onUpPressed: Launcher.selectPrev()
    Keys.onDownPressed: Launcher.selectNext()

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        SearchField {
            id: searchField
            Layout.fillWidth: true
            placeholder: "Search apps, files, web..."
            focus: true

            onSearchTextChanged: newText => Launcher.setText(newText)
            onSearchAccepted: Launcher.activateSelected()

            Connections {
                target: Launcher

                function onTextChanged(): void {
                    if (searchField.text !== Launcher.text) searchField.text = Launcher.text
                }
            }
        }

        ResultsList {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(400, implicitHeight)
            Layout.minimumHeight: 100
            results: Launcher.results
            selectedIndex: Launcher.selectedIndex

            onItemClicked: index => Launcher.activate(index)
            onItemHovered: index => Launcher.select(index)
        }

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            visible: Launcher.results.length === 0
            horizontalAlignment: Text.AlignHCenter
            color: Colors.textDim
            text: Launcher.text === ""
                ? "Type to search applications, files, or use prefixes:\n>files  >clip  >win  >run  >web"
                : "No results for \"" + Launcher.text + "\""
        }
    }
}
