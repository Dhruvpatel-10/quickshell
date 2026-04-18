import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property int percent: 0

    function set(p) {
        const clamped = Math.max(1, Math.min(100, Math.round(p)))
        setProc.command = ["brightnessctl", "set", clamped + "%"]
        setProc.running = true
        root.percent = clamped
    }

    property Process query: Process {
        command: ["sh", "-c", "echo $(( $(brightnessctl g) * 100 / $(brightnessctl m) ))"]
        stdout: StdioCollector {
            onStreamFinished: root.percent = parseInt(text.trim()) || 0
        }
    }

    property Process setProc: Process {}

    property Timer timer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.query.running = true
    }
}
