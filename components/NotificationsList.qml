import QtQuick
import Quickshell.Services.Notifications
import ".."

Column {
    id: root
    spacing: 8

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true
    }

    Row {
        width: parent.width
        Text {
            text: "Notifications"
            color: Theme.fg
            font { family: Theme.fontSans; pixelSize: 13; weight: Font.DemiBold }
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - clearBtn.width
        }
        Rectangle {
            id: clearBtn
            width: 72; height: 24; radius: 12
            color: clearMouse.containsMouse ? Theme.tileBgActive : Theme.tileBg
            visible: server.trackedNotifications.values.length > 0
            Text {
                anchors.centerIn: parent
                text: "Clear All"
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
            }
            MouseArea {
                id: clearMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    const arr = server.trackedNotifications.values.slice()
                    for (const n of arr) n.dismiss()
                }
            }
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }

    Repeater {
        model: server.trackedNotifications
        delegate: NotificationItem {
            required property var modelData
            notification: modelData
            width: root.width
        }
    }

    Text {
        visible: server.trackedNotifications.values.length === 0
        text: "No notifications"
        color: Theme.fgMuted
        font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall }
    }
}
