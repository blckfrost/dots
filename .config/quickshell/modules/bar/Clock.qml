import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.shared

Item {
    id: root

    property string timeString: ""
    property string dateString: ""

    height: parent.height
    width: frame.implicitWidth + 6

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
                text: root.timeString + " " + root.dateString
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            var hours = String(now.getHours()).padStart(2, '0');
            var minutes = String(now.getMinutes()).padStart(2, '0');
            root.timeString = hours + ":" + minutes;

            var day = String(now.getDate()).padStart(2, '0');
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var year = now.getFullYear();
            root.dateString = day + "-" + month + "-" + year;
        }
    }
}
