import QtQuick
import Quickshell.Services.Notifications
import ".."

Rectangle {
    id: root
    required property Notification notification

    implicitHeight: 58
    color: Theme.tileBg
    radius: Theme.radiusTile

    Row {
        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
        spacing: 10

        Rectangle {
            width: 36; height: 36; radius: 18
            color: Theme.bgAlt
            anchors.verticalCenter: parent.verticalCenter
            Text {
                anchors.centerIn: parent
                text: "\uf0f3"
                color: Theme.fg
                font { family: Theme.fontMono; pixelSize: 14 }
            }
        }

        Column {
            width: parent.width - 36 - 10 - 24 - 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1
            Text {
                text: root.notification.summary
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSize; weight: Font.DemiBold }
                elide: Text.ElideRight; width: parent.width
            }
            Text {
                text: root.notification.body
                color: Theme.fgMuted
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall }
                elide: Text.ElideRight; width: parent.width
                visible: text.length > 0
            }
            Text {
                text: root.notification.appName
                color: Theme.fgDim
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall }
                elide: Text.ElideRight; width: parent.width
            }
        }

        IconButton {
            width: 24; height: 24; radius: 12
            icon: "\uf00d"; iconSize: 9
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.notification.dismiss()
        }
    }
}
