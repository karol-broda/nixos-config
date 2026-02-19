import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.services
import qs.widgets.text
import qs.widgets.inputs
import "sections"

Panel {
    id: root

    slideFrom: "top"
    open: screenActive && Dispatcher.activePanel === "launcher"

    property bool screenActive: true

    targetWidth: 500
    targetHeight: content.implicitHeight + Spacing.panelPadding * 2

    LauncherState {
        id: state
    }

    onOpenChanged: {
        if (open) {
            searchField.forceActiveFocus()
            state.search("")
        } else {
            state.reset()
            searchField.clear()
        }
    }

    Keys.onEscapePressed: {
        Dispatcher.dispatch(Actions.closePanel())
    }
    Keys.onUpPressed: state.selectPrev()
    Keys.onDownPressed: state.selectNext()

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Spacing.panelPadding
        spacing: Spacing.spacingMd

        SearchField {
            id: searchField
            Layout.fillWidth: true
            placeholder: "Search apps, files, web..."

            onSearchTextChanged: function(newText) {
                state.search(newText)
            }

            onSearchAccepted: {
                if (state.activateSelected()) {
                    Dispatcher.dispatch(Actions.closePanel())
                }
            }

            onEscapePressed: {
                Dispatcher.dispatch(Actions.closePanel())
            }
        }

        ResultsList {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(400, implicitHeight)
            Layout.minimumHeight: 100
            results: state.results
            selectedIndex: state.selectedIndex

            onItemClicked: function(index) {
                state.selectedIndex = index
                if (state.activateSelected()) {
                    Dispatcher.dispatch(Actions.closePanel())
                }
            }

            onItemHovered: function(index) {
                state.selectedIndex = index
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            visible: state.results.length === 0 && state.query === ""

            Label {
                anchors.centerIn: parent
                text: "Type to search applications, files, or use prefixes:\n>files  >clip  >win  >run  >web"
                horizontalAlignment: Text.AlignHCenter
                color: Colors.textDim
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            visible: state.results.length === 0 && state.query !== ""

            Label {
                anchors.centerIn: parent
                text: "No results for \"" + state.query + "\""
                color: Colors.textDim
            }
        }
    }
}
