import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services
import qs.widgets.indicators
import qs.widgets.text

ColumnLayout {
    id: root

    spacing: Spacing.spacingSm

    Component.onCompleted: SystemUsage.refCount++
    Component.onDestruction: SystemUsage.refCount--

    Label {
        text: "System"
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Spacing.spacingSm

        Label {
            text: "CPU"
            Layout.preferredWidth: 40
        }

        Progress {
            Layout.fillWidth: true
            value: SystemUsage.cpuPerc
        }

        Label {
            text: Math.round(SystemUsage.cpuPerc * 100) + "%"
            Layout.preferredWidth: 36
            horizontalAlignment: Text.AlignRight
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Spacing.spacingSm

        Label {
            text: "RAM"
            Layout.preferredWidth: 40
        }

        Progress {
            Layout.fillWidth: true
            value: SystemUsage.memPerc
        }

        Label {
            text: Math.round(SystemUsage.memPerc * 100) + "%"
            Layout.preferredWidth: 36
            horizontalAlignment: Text.AlignRight
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Spacing.spacingSm

        Label {
            text: "Disk"
            Layout.preferredWidth: 40
        }

        Progress {
            Layout.fillWidth: true
            value: SystemUsage.storagePerc
        }

        Label {
            text: Math.round(SystemUsage.storagePerc * 100) + "%"
            Layout.preferredWidth: 36
            horizontalAlignment: Text.AlignRight
        }
    }
}
