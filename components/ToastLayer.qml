import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: root
    visible: Notifs.toasts.length > 0
    anchors { top: true; right: true }
    margins { top: Theme.barHeight + 6; right: 10 }
    implicitWidth: 360
    implicitHeight: Math.min(list.implicitHeight + 16, 500)
    color: "transparent"
    exclusiveZone: 0

    Column {
        id: list
        anchors.centerIn: parent
        width: parent.width - 16
        spacing: 8

        Repeater {
            model: Notifs.toasts
            delegate: Toast {
                required property var modelData
                notification: modelData
                width: parent.width
            }
        }
    }
}
