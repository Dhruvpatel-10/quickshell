import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property int cpu: 0
    property int ram: 0
    property int disk: 0

    property var _prev: ({ idle: 0, total: 0 })

    property Process query: Process {
        command: ["sh", "-c",
            "cat /proc/stat | awk '/^cpu /{printf \"%d %d\\n\", $5, $2+$3+$4+$5+$6+$7+$8}';" +
            "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%d\\n\", (t-a)*100/t}' /proc/meminfo;" +
            "df --output=pcent / | tail -1 | tr -dc '0-9'"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                if (lines.length < 3) return
                const cpuParts = lines[0].split(" ")
                const idle = parseInt(cpuParts[0])
                const total = parseInt(cpuParts[1])
                const dIdle = idle - root._prev.idle
                const dTotal = total - root._prev.total
                if (dTotal > 0) root.cpu = Math.round(100 * (1 - dIdle / dTotal))
                root._prev = { idle, total }
                root.ram = parseInt(lines[1]) || 0
                root.disk = parseInt(lines[2]) || 0
            }
        }
    }

    property Timer timer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.query.running = true
    }
}
