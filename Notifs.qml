pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

NotificationServer {
    id: root

    keepOnReload: true
    bodySupported: true
    actionsSupported: true
    imageSupported: true
    persistenceSupported: true

    property var toasts: []
    readonly property int toastTimeoutMs: 5000

    onNotification: n => {
        n.tracked = true
        toasts = [...toasts, n]
        const t = toastTimerComponent.createObject(root, { target: n })
        t.running = true
    }

    function dismissAll() {
        const list = trackedNotifications.values.slice()
        for (const n of list) n.dismiss()
        toasts = []
    }

    function _expireToast(n) {
        toasts = toasts.filter(t => t !== n)
    }

    property Component toastTimerComponent: Component {
        Timer {
            property var target: null
            interval: root.toastTimeoutMs
            repeat: false
            onTriggered: {
                root._expireToast(target)
                destroy()
            }
        }
    }
}
