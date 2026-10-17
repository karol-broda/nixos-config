pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.core
import qs.theme
import qs.services
import qs.widgets.indicators
import qs.widgets.text

ColumnLayout {
    id: root

    property bool active: false

    spacing: Spacing.spacingSm

    Lease {
        target: SystemUsage
        active: root.active
    }

    Label {
        text: "System"
    }

    Repeater {
        model: [
            { label: "CPU", value: () => SystemUsage.cpuPerc },
            { label: "RAM", value: () => SystemUsage.memPerc },
            { label: "Disk", value: () => SystemUsage.storagePerc }
        ]

        RowLayout {
            id: row

            required property var modelData
            readonly property real value: modelData.value()

            Layout.fillWidth: true
            spacing: Spacing.spacingSm

            Label {
                text: row.modelData.label
                Layout.preferredWidth: 40
            }

            Progress {
                Layout.fillWidth: true
                value: row.value
            }

            Label {
                text: Math.round(row.value * 100) + "%"
                Layout.preferredWidth: 36
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
