import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import ".."
import "../services"

PanelWindow {
    id: bar
    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight
    color: Theme.bg

    // Poll services
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
            Icon { text: net.connected ? "\uf1eb" : "\uf6ac"; color: net.connected ? Theme.fg : Theme.fgMuted }
            Text {
                text: net.ssid || "—"
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 100)
            }
            Rectangle { width: 1; height: 12; color: Theme.border; anchors.verticalCenter: parent.verticalCenter; visible: bt.connected }
            Icon { text: "\uf293"; color: bt.connected ? Theme.fg : Theme.fgMuted; visible: bt.connected }
            Text {
                visible: bt.connected
                text: bt.device
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 80)
            }
        }

        // Pill 2 — Brightness + Volume
        Pill {
            Icon { text: "\uf185"; color: Theme.fg }
            Text {
                text: brightness.percent
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle { width: 1; height: 12; color: Theme.border; anchors.verticalCenter: parent.verticalCenter }
            Icon {
                text: (Pipewire.defaultAudioSink?.audio?.muted ?? false) ? "\uf6a9" : "\uf028"
                color: Theme.fg
            }
            Text {
                text: Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100)
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Pill 3 — Battery + settings gear
        Pill {
            Icon {
                text: UPower.displayDevice.iconName ? "" : "\uf240"
                color: {
                    if (!UPower.displayDevice.isPresent) return Theme.fgMuted
                    const p = UPower.displayDevice.percentage * 100
                    if (p < 15) return Theme.critical
                    if (p < 30) return Theme.warn
                    return Theme.fg
                }
            }
            Text {
                text: UPower.displayDevice.isPresent
                      ? Math.round(UPower.displayDevice.percentage * 100) + "%"
                      : "—"
                color: Theme.fg
                font { family: Theme.fontSans; pixelSize: Theme.fontSizeSmall; weight: Font.Medium }
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle { width: 1; height: 12; color: Theme.border; anchors.verticalCenter: parent.verticalCenter }
            Icon { text: "\uf013"; color: Theme.fg }

            onClicked: State.controlCenterOpen = !State.controlCenterOpen
        }
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
}
