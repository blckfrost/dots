import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.shared

Item {
    id: root

    property string hostname: ""

    height: parent.height
    width: frame.implicitWidth + 6

    Process {
        id: hostnameProc
        command: ["sh", "-c", "echo $(whoami)@$(hostname)"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.hostname = data.trim();
                hostnameProc.running = false;
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
                text: ""
                color: Theme.textAccent
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Text {
                text: root.hostname
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
        }
    }
}
