import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import ".."
import "../services"

PanelWindow {
    id: root
    visible: Ui.controlCenterOpen
    anchors { top: true; right: true; left: true; bottom: true }
    margins { top: Theme.barHeight }
    color: "#01000000"
    exclusiveZone: 0

    Brightness { id: brightness }
    SystemStats { id: stats }

    // Full-area dismiss layer — any click outside the card closes the drawer.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true
        onPressed: Ui.controlCenterOpen = false
    }


    Rectangle {
        id: card
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 8
            rightMargin: 10
        }
        width: Theme.controlCenterWidth
        height: body.implicitHeight + Theme.padLg * 2
        color: Theme.card
        radius: 20
        border.color: Theme.border
        border.width: 1

        // Absorb clicks that hit empty card space so they don't close the drawer.
        MouseArea { anchors.fill: parent }

        Column {
            id: body
            anchors {
                fill: parent
                margins: Theme.padLg
            }
            spacing: 12

            // Header — clock / date / buttons
            RowLayout {
                width: parent.width
                Column {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: Qt.formatTime(clockTick.time, "HH:mm")
                        color: Theme.fg
                        font { family: Theme.fontSans; pixelSize: Theme.fontSizeXL; weight: Font.DemiBold }
                    }
                    Text {
                        text: Qt.formatDate(clockTick.time, "dddd, MMMM d")
                        color: Theme.fgMuted
                        font { family: Theme.fontSans; pixelSize: Theme.fontSize }
                    }
                }
                IconButton { icon: "\uf013" }
                IconButton { icon: "\uf0c9" }
                IconButton { icon: "\uf011"; iconColor: Theme.critical }
            }

            // Toggle grid
            Grid {
                width: parent.width
                columns: 2
                columnSpacing: 8
                rowSpacing: 8

                ToggleTile {
                    icon: "\uf1eb"
                    label: "Wi-Fi"
                    subtitle: "Connected"
                    active: true
                }
                ToggleTile {
                    icon: "\uf293"
                    label: "Bluetooth"
                    subtitle: "On"
                    active: true
                }
                ToggleTile {
                    icon: "\uf1f6"
                    label: "Do Not Dist..."
                    subtitle: Ui.dndOn ? "On" : "Off"
                    active: Ui.dndOn
                    onClicked: Ui.dndOn = !Ui.dndOn
                }
                ToggleTile {
                    icon: "\uf0f4"
                    label: "Caffeine"
                    subtitle: Ui.caffeineOn ? "On" : "Off"
                    active: Ui.caffeineOn
                    onClicked: Ui.caffeineOn = !Ui.caffeineOn
                }
            }

            ToggleTile {
                width: parent.width
                wide: true
                icon: "\uf030"
                label: "Screenshot"
                subtitle: "Capture Screen"
            }

            Rectangle { width: parent.width; height: 1; color: Theme.border; opacity: 0.5 }

            SliderRow {
                width: parent.width
                icon: (Pipewire.defaultAudioSink?.audio?.muted ?? false) ? "\uf6a9" : "\uf028"
                value: Pipewire.defaultAudioSink?.audio?.volume ?? 0
                onMoved: v => { if (Pipewire.defaultAudioSink?.audio) Pipewire.defaultAudioSink.audio.volume = v }
            }

            SliderRow {
                width: parent.width
                icon: "\uf185"
                value: brightness.percent / 100
                onMoved: v => brightness.set(v * 100)
            }

            Rectangle { width: parent.width; height: 1; color: Theme.border; opacity: 0.5 }

            Row {
                width: parent.width
                spacing: 8
                StatCard { width: (parent.width - 16) / 3; icon: "\uf2db"; label: "CPU"; percent: stats.cpu }
                StatCard { width: (parent.width - 16) / 3; icon: "\uf538"; label: "RAM"; percent: stats.ram }
                StatCard { width: (parent.width - 16) / 3; icon: "\uf0a0"; label: "Disk"; percent: stats.disk }
            }

            MediaCard { width: parent.width }

            NotificationsList { width: parent.width }
        }
    }

    Timer {
        id: clockTick
        property date time: new Date()
        interval: 1000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: time = new Date()
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
}
