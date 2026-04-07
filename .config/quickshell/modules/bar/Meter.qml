import QtQuick
import QtQuick.Layouts

import qs.shared

Item {
    id: root

    property int percentage: 0
    property string name: "CPU"
    property string value: "0%"

    height: parent.height
    width: frame.width + 6

    function getAsciiBar(percent) {
        var bars = ["░░░░░░░░░░", "█░░░░░░░░░", "██░░░░░░░░", "███░░░░░░░", "████░░░░░░", "█████░░░░░", "██████░░░░", "███████░░░", "████████░░", "█████████░", "██████████"];
        var index = Math.max(0, Math.min(10, Math.round(percent / 10)));
        return bars[index];
    }

    function getBarColor(percent) {
        if (percent < 60) {
            return Theme.textAccent; // Green for normal usage
        } else if (percent < 70) {
            return "#ffa500"; // Orange
        } else if (percent < 80) {
            return "#ff6b35"; // Orange-red
        } else if (percent < 90) {
            return "#ff4444"; // Light red
        } else {
            return Theme.accentRed; // Full red for critical
        }
    }

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 4

            Text {
                text: root.name
                color: Theme.textPrimaryDim
                font.family: Theme.fontFamily
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.getAsciiBar(root.percentage)
                color: root.getBarColor(root.percentage)
                font.family: Theme.fontFamily
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.value
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
