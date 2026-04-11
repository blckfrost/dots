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
            return Theme.textAccent; // Muted green for normal usage
        } else if (percent < 70) {
            return "#b89066"; // Muted orange
        } else if (percent < 80) {
            return "#b87858"; // Muted orange-red
        } else if (percent < 90) {
            return "#b86666"; // Muted red
        } else {
            return Theme.accentRed; // Deeper red for critical
        }
    }

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 6

        Row {
            spacing: 4

            Text {
                text: root.name
                color: Theme.textPrimaryDim
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Text {
                text: root.getAsciiBar(root.percentage)
                color: root.getBarColor(root.percentage)
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Text {
                text: root.value
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
        }
    }
}
