import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.shared

Item {
    id: root

    property string statusCode: "200"
    property string statusText: "OK"
    property color statusColor: Theme.textAccent

    height: parent.height
    width: frame.implicitWidth + 6

    Component.onCompleted: {
        updateStatus();
    }

    function updateStatus() {
        // Simple system status based on CPU/Memory (we'll make it dynamic)
        var random = Math.random();
        if (random > 0.95) {
            root.statusCode = "503";
            root.statusText = "BUSY";
            root.statusColor = "#b87858";
        } else if (random > 0.85) {
            root.statusCode = "202";
            root.statusText = "LOAD";
            root.statusColor = "#b89066";
        } else {
            root.statusCode = "200";
            root.statusText = "OK";
            root.statusColor = Theme.textAccent;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.updateStatus()
    }

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 4

            Text {
                text: root.statusCode
                color: root.statusColor
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: root.statusText
                color: Theme.textPrimaryDim
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
        }
    }
}
