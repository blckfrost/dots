import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.shared

Item {
    id: root

    property string hexValue: "0x00000000"

    height: parent.height
    width: frame.implicitWidth + 6

    function generateHex() {
        var hex = "0x";
        for (var i = 0; i < 8; i++) {
            hex += Math.floor(Math.random() * 16).toString(16).toUpperCase();
        }
        return hex;
    }

    Component.onCompleted: {
        root.hexValue = generateHex();
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            if (Math.random() > 0.5) {
                root.hexValue = root.generateHex();
            }
        }
    }

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 4

            Text {
                text: "MEM"
                color: Theme.textPrimaryDim
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Text {
                text: root.hexValue
                color: Theme.textAccent
                font.family: "monospace"
                font.pixelSize: 12
            }
        }
    }
}
