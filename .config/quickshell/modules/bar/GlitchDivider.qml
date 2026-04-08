import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.shared

Item {
    id: root

    property string displayText: "│"
    property var glitchChars: ["│", "┃", "║", "▌", "▐", "█", "▓", "▒", "░", "╎", "╏", "┆", "┇", "┊", "┋"]

    height: parent.height
    width: glitchText.width + 8

    Text {
        id: glitchText
        text: root.displayText
        color: Theme.textPrimaryDim
        font.family: Theme.fontFamily
        font.pixelSize: 12
        anchors.centerIn: parent
        opacity: 0.3
    }

    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: {
            if (Math.random() > 0.7) {
                root.displayText = root.glitchChars[Math.floor(Math.random() * root.glitchChars.length)];
            } else {
                root.displayText = "│";
            }
        }
    }
}
