import QtQuick
import qs.services

Item {
    id: root

    property string query: ""
    property int selectedIndex: 0
    property var results: []

    visible: false
    width: 0
    height: 0

    function search(text) {
        query = text
        selectedIndex = 0

        // use cached results immediately to prevent empty-state flash
        // while the async query runs in the background
        const cached = Elephant.results
        if (cached !== null && cached !== undefined && cached.length > 0) {
            results = cached
        }

        Elephant.query(text)
    }

    function selectNext() {
        if (selectedIndex < results.length - 1) {
            selectedIndex++
        }
    }

    function selectPrev() {
        if (selectedIndex > 0) {
            selectedIndex--
        }
    }

    function activateSelected() {
        if (results.length > 0 && selectedIndex >= 0 && selectedIndex < results.length) {
            Elephant.activate(results[selectedIndex])
            return true
        }
        return false
    }

    function reset() {
        query = ""
        selectedIndex = 0
        results = []
    }

    Connections {
        target: Elephant

        function onResultsReady() {
            root.results = Elephant.results
            root.selectedIndex = 0
        }
    }
}
