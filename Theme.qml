pragma Singleton
import QtQuick

QtObject {
    readonly property color bg: "#13151c"
    readonly property color bgAlt: "#0e1016"
    readonly property color bgSurface: "#1d2029"
    readonly property color pillBg: "#1d2029"
    readonly property color tileBg: "#22252f"
    readonly property color tileBgActive: "#2f3340"
    readonly property color card: "#181b23"

    readonly property color fg: "#cdc8bc"
    readonly property color fgMuted: "#817c72"
    readonly property color fgDim: "#5a564e"

    readonly property color accent: "#c9943e"
    readonly property color accentAlt: "#6a9fb5"
    readonly property color success: "#7ab87f"
    readonly property color warn: "#d4a843"
    readonly property color critical: "#c45c5c"
    readonly property color border: "#282c38"

    readonly property string fontSans: "IBM Plex Sans"
    readonly property string fontMono: "MesloLGS Nerd Font Mono"
    readonly property int fontSize: 11
    readonly property int fontSizeSmall: 10
    readonly property int fontSizeLarge: 14
    readonly property int fontSizeXL: 26

    readonly property int barHeight: 38
    readonly property int radius: 10
    readonly property int radiusPill: 18
    readonly property int radiusTile: 14
    readonly property int gap: 6
    readonly property int pad: 10
    readonly property int padLg: 16

    readonly property int controlCenterWidth: 420
}
