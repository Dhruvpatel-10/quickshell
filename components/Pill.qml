import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    default property alias content: row.data
    property int padding: Theme.pad
    property int spacing: 8
    signal clicked()

    color: mouseArea.containsMouse ? Theme.tileBg : Theme.pillBg
    radius: Theme.radiusPill
    height: 28
    implicitWidth: row.implicitWidth + padding * 2

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: root.spacing
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    Behavior on color { ColorAnimation { duration: 120 } }
}
