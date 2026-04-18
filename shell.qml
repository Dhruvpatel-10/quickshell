import Quickshell
import "."
import "./components"

ShellRoot {
    Variants {
        model: Quickshell.screens
        Bar { screen: modelData }
    }
    ControlCenter {}
}
