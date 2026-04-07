pragma Singleton

import QtQuick
import Quickshell

Singleton {

    // SECTION Primitives

    readonly property color gray50: "#ffffff"
    readonly property color gray100: "#CACACA"
    readonly property color gray200: "#D9D9D9"
    readonly property color gray300: "#c3c3c3"
    readonly property color gray500: "#7a7a7a"
    readonly property color gray800: "#0E0E0E"

    readonly property color accentGreen: "#1bfd9c"
    readonly property color accentRed: "#fc3e38"

    // SECTION Theme

    readonly property color background: gray800

    readonly property color ctosGray: gray200

    readonly property color textPrimary: gray50
    readonly property color textPrimaryDim: gray100
    readonly property color textPrimaryDimmer: gray300

    readonly property color textSecondary: gray500
    readonly property color secondary: gray500

    readonly property color textAccent: accentGreen

    readonly property color success: accentGreen
    readonly property color error: accentRed

    // SECTION Fonts

    property string fontFamily: "JetBrainsMono Nerd Font"
}
// pragma Singleton
//
// import QtQuick
// import Quickshell
//
// Singleton {
//
//     // SECTION Primitives
//     //
//     readonly property color _white: "#ffffff"
//     readonly property color _gray100: "#CACACA"
//     readonly property color _gray200: "#D9D9D9"
//     readonly property color _gray300: "#c3c3c3"
//     readonly property color _gray500: "#7a7a7a"
//     readonly property color _gray800: "#0E0E0E"
//     readonly property color _green: "#1bfd9c"
//     readonly property color _red: "#fc3e38"
//
//     // SECTION Font
//     readonly property string fontFamily: "JetBrainsMono Nerd Font"
//
//     property QtObject colors: QtObject {
//         readonly property color layer0: _gray800        // app/bar background
//         readonly property color layer1: Qt.lighter(_gray800, 1.15)  // panels, cards
//         readonly property color layer2: Qt.lighter(_gray800, 1.30)  // elevated elements
//
//         // Text on each layer
//         readonly property color onLayer0: _white
//         readonly property color onLayer1: _gray100
//         readonly property color onLayer2: _gray200
//
//         // Dim variants for inactive/secondary text
//         readonly property color onLayer0Dim: _gray100
//         readonly property color onLayer0Dimmer: _gray300
//         readonly property color subtext: _gray500
//
//         // Interactive states (derived, no hardcoding needed)
//         readonly property color layer1Hover: Qt.lighter(layer1, 1.1)
//         readonly property color layer1Active: Qt.lighter(layer1, 1.2)
//         readonly property color layer2Hover: Qt.lighter(layer2, 1.1)
//         readonly property color layer2Active: Qt.lighter(layer2, 1.2)
//
//         // Accent
//         readonly property color primary: _green
//         readonly property color onPrimary: _gray800
//         readonly property color error: _red
//         readonly property color onError: _white
//
//         // Outline
//         readonly property color outline: _gray500
//         readonly property color outlineVariant: _gray300
//     }
// }
//

