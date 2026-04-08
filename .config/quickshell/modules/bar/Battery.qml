import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.shared

Item {
    id: root

    property int percentage: 0
    property string status: "Unknown"
    property bool isCharging: false
    property string value: "0%"

    height: parent.height
    width: frame.width + 6

    function getAsciiBar(percent) {
        var bars = ["░░░░░░░░░░", "█░░░░░░░░░", "██░░░░░░░░", "███░░░░░░░", "████░░░░░░", "█████░░░░░", "██████░░░░", "███████░░░", "████████░░", "█████████░", "██████████"];
        var index = Math.max(0, Math.min(10, Math.round(percent / 10)));
        return bars[index];
    }

    function getBarColor(percent, charging) {
        if (charging) {
            return Theme.textAccent; // Muted green when charging
        }
        if (percent > 60) {
            return Theme.textAccent; // Muted green for good battery
        } else if (percent > 30) {
            return "#b89066"; // Muted orange for medium
        } else if (percent > 15) {
            return "#b87858"; // Muted orange-red for low
        } else {
            return Theme.accentRed; // Muted red for critical
        }
    }

    function getBatteryIcon(charging) {
        if (charging) {
            return "󱐋"; // Nerd Font charging icon
        }
        return ""; // Nerd Font battery icon
    }

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 4

            Text {
                text: root.getBatteryIcon(root.isCharging)
                color: root.getBarColor(root.percentage, root.isCharging)
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Text {
                text: root.getAsciiBar(root.percentage)
                color: root.getBarColor(root.percentage, root.isCharging)
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

    // Battery status reader
    Process {
        id: batteryProc
        command: ["sh", "-c", "while true; do echo \"$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 0) $(cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo Unknown)\"; sleep 5; done"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/);
                if (parts.length >= 2) {
                    var capacity = parseInt(parts[0]);
                    var stat = parts[1].trim();
                    
                    root.percentage = capacity;
                    root.value = capacity + "%";
                    root.status = stat;
                    root.isCharging = (stat === "Charging" || stat === "Full");
                }
            }
        }
    }
}
