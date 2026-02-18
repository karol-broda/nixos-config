import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.core
import qs.widgets.containers
import qs.widgets.icons
import qs.widgets.text
import qs.widgets.buttons

Card {
    id: root

    property var notification: null

    implicitHeight: cardContent.implicitHeight + Spacing.paddingMd * 2

    ColumnLayout {
        id: cardContent
        anchors.fill: parent
        spacing: Spacing.spacingSm

        RowLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingSm

            AppIcon {
                iconName: {
                    if (root.notification === null || root.notification === undefined) return ""
                    return root.notification.appIcon || ""
                }
                size: Spacing.iconSm
            }

            Label {
                Layout.fillWidth: true
                text: {
                    if (root.notification === null || root.notification === undefined) return ""
                    return root.notification.appName || "Unknown"
                }
            }

            Label {
                text: {
                    if (root.notification === null || root.notification === undefined) return ""
                    return root.notification.timeStr || "now"
                }
                color: Colors.textDim
            }

            IconButton {
                icon: "x"
                size: 24
                iconSize: Spacing.iconSm

                onClicked: {
                    if (root.notification !== null && root.notification !== undefined) {
                        Dispatcher.dispatch(Actions.dismissNotification(root.notification.id))
                    }
                }
            }
        }

        Heading {
            Layout.fillWidth: true
            text: {
                if (root.notification === null || root.notification === undefined) return ""
                return root.notification.summary || ""
            }
            visible: text !== ""
            wrapMode: Text.Wrap
            maximumLineCount: 2
        }

        Body {
            Layout.fillWidth: true
            text: {
                if (root.notification === null || root.notification === undefined) return ""
                return root.notification.body || ""
            }
            visible: text !== ""
            wrapMode: Text.Wrap
            maximumLineCount: 4
            color: Colors.textSecondary
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Spacing.spacingSm
            visible: {
                if (root.notification === null || root.notification === undefined) return false
                const actions = root.notification.actions
                return actions !== null && actions !== undefined && actions.length > 0
            }

            Repeater {
                model: {
                    if (root.notification === null || root.notification === undefined) return []
                    return root.notification.actions || []
                }

                TextButton {
                    required property var modelData

                    text: modelData.text || ""
                    onClicked: {
                        if (modelData.invoke !== null && modelData.invoke !== undefined && typeof modelData.invoke === "function") {
                            modelData.invoke()
                        }
                    }
                }
            }
        }
    }
}
