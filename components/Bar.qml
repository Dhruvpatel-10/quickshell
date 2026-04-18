import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import ".."
import "../services"

PanelWindow {
    id: bar
    property var modelData
    screen: modelData
    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight
    color: Theme.bg

    Net { id: net }
    Bt { id: bt }
    Brightness { id: brightness }

    Row {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 10
        }
        spacing: 6

        // Pill 1 — Wi-Fi SSID + Bluetooth device
        Pill {
            Icon {
                text: net.connected ? "\uf1eb" : "\uf6ac"
                color: net.connected ? Theme.fg : Theme.fgMuted
                Layout.alignment: Qt.AlignVCenter
            }
            Text {
                text: net.ssid || "—"
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumWidth: 100
                elide: Text.ElideRight
            }
            Rectangle {
                visible: bt.connected
                Layout.preferredWidth: 1
                Layout.preferredHeight: 12
                Layout.alignment: Qt.AlignVCenter
                color: Theme.border
            }
            Icon {
                visible: bt.connected
                text: "\uf293"
                color: bt.connected ? Theme.fg : Theme.fgMuted
                Layout.alignment: Qt.AlignVCenter
            }
            Text {
                visible: bt.connected
                text: bt.device
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumWidth: 80
                elide: Text.ElideRight
            }
        }

        // Pill 2 — Brightness + Volume
        Pill {
            Icon { text: "\uf185"; color: Theme.fg; Layout.alignment: Qt.AlignVCenter }
            Text {
                text: brightness.percent
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                Layout.alignment: Qt.AlignVCenter
            }
            Rectangle {
                Layout.preferredWidth: 1; Layout.preferredHeight: 12
                Layout.alignment: Qt.AlignVCenter
                color: Theme.border
            }
            Icon {
                text: (Pipewire.defaultAudioSink?.audio?.muted ?? false) ? "\uf6a9" : "\uf028"
                color: Theme.fg
                Layout.alignment: Qt.AlignVCenter
            }
            Text {
                text: Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100)
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // Pill 3 — Battery + settings gear
        Pill {
            Icon {
                text: "\uf240"
                color: {
                    if (!UPower.displayDevice.isPresent) return Theme.fgMuted
                    const p = UPower.displayDevice.percentage * 100
                    if (p < 15) return Theme.critical
                    if (p < 30) return Theme.warn
                    return Theme.fg
                }
                Layout.alignment: Qt.AlignVCenter
            }
            Text {
                text: UPower.displayDevice.isPresent
                      ? Math.round(UPower.displayDevice.percentage * 100) + "%"
                      : "—"
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                Layout.alignment: Qt.AlignVCenter
            }
            Rectangle {
                Layout.preferredWidth: 1; Layout.preferredHeight: 12
                Layout.alignment: Qt.AlignVCenter
                color: Theme.border
            }
            Icon { text: "\uf013"; color: Theme.fg; Layout.alignment: Qt.AlignVCenter }

            onClicked: Ui.controlCenterOpen = !Ui.controlCenterOpen
        }
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
}
