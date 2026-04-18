import QtQuick
import QtQuick.Controls
import ".."

Item {
    id: root
    property string icon: ""
    property real value: 0
    property int percent: Math.round(value * 100)
    signal moved(real v)

    implicitHeight: 36

    Row {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            width: 28; height: 28; radius: 14
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            Text {
                anchors.centerIn: parent
                text: root.icon
                color: Theme.fg
                font { family: Theme.fontMono; pixelSize: 16 }
            }
        }

        Slider {
            id: slider
            width: parent.width - 28 - 48 - 12 * 2
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            from: 0; to: 1
            value: root.value
            onMoved: root.moved(value)

            background: Rectangle {
                x: slider.leftPadding
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                width: slider.availableWidth
                height: 18
                radius: 9
                color: Theme.bgAlt
                Rectangle {
                    width: slider.visualPosition * parent.width
                    height: parent.height
                    radius: 9
                    color: Theme.fg
                }
            }
            handle: Item {}
        }

        Text {
            width: 48
            anchors.verticalCenter: parent.verticalCenter
            text: root.percent + "%"
            color: Theme.fg
            font { family: Theme.fontSans; pixelSize: Theme.fontSize; weight: Font.Medium }
            horizontalAlignment: Text.AlignRight
        }
    }
}
