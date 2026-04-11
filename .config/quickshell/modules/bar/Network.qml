import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.shared

Item {
    id: root

    required property var window

    property string interfaceName: "..."
    property string networkName: "..."
    property string connectionType: "wifi"
    property real uploadSpeed: 0
    property real downloadSpeed: 0
    property string ipAddress: "..."
    property bool showTooltip: false
    property var trafficHistory: []

    height: parent.height
    width: frame.implicitWidth + 6

    function formatBytes(bytes) {
        if (bytes < 1024)
            return bytes.toFixed(0) + "B/s";
        if (bytes < 1024 * 1024)
            return (bytes / 1024).toFixed(1) + "KB/s";
        return (bytes / 1024 / 1024).toFixed(1) + "MB/s";
    }

    function getConnectionGraph() {
        var maxVal = 1;
        for (var i = 0; i < root.trafficHistory.length; i++) {
            maxVal = Math.max(maxVal, root.trafficHistory[i]);
        }

        var bars = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"];
        var graph = "";
        for (var j = 0; j < Math.min(20, root.trafficHistory.length); j++) {
            var val = root.trafficHistory[j];
            var index = Math.min(7, Math.floor((val / maxVal) * 8));
            graph += bars[index];
        }
        return graph || "▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁";
    }

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 4

            Text {
                text: root.connectionType === "wifi" ? "" : ""
                color: Theme.textAccent
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Text {
                text: root.networkName
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }
        }
    }

    // MouseArea covering the entire root item
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            networkTooltip.visible = true;
            console.log("Network tooltip shown");
        }
        onExited: {
            networkTooltip.visible = false;
            console.log("Network tooltip hidden");
        }
    }

    // Tooltip as PopupWindow
    PopupWindow {
        id: networkTooltip
        visible: false

        anchor {
            window: root.window
            rect.x: root.x + root.width / 2
            rect.y: root.window.height - 4
            adjustment: PopupAdjustment.SlideX | PopupAdjustment.SlideY
        }

        width: tooltipContent.width + 16
        height: tooltipContent.height + 16

        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0.1, 0.1, 0.1, 0.95)
            border.color: Theme.textPrimary
            border.width: 1

            Column {
                id: tooltipContent
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: "┌─[ " + (root.connectionType === "wifi" ? "WIFI" : "NET") + " ]─────────────────"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ Network: " + root.networkName
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ Interface: " + root.interfaceName
                    color: Theme.textPrimaryDim
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ IP: " + root.ipAddress
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "├─────────────────────"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ ↑ " + root.formatBytes(root.uploadSpeed)
                    color: "#b87858"
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ ↓ " + root.formatBytes(root.downloadSpeed)
                    color: Theme.textAccent
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ Traffic Graph:"
                    color: Theme.textPrimaryDim
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ " + root.getConnectionGraph()
                    color: Theme.textAccent
                    font.family: "monospace"
                    font.pixelSize: 11
                }

                Text {
                    text: "└─────────────────────"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }
            }
        }
    }

    // Get WiFi SSID
    Process {
        id: ssidProc
        command: ["sh", "-c", "while true; do nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 || iwgetid -r 2>/dev/null || echo '...'; sleep 1; done"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                if (trimmed !== "" && trimmed !== "...") {
                    root.networkName = trimmed;
                    root.connectionType = "wifi";
                } else if (root.interfaceName !== "...") {
                    root.networkName = root.interfaceName;
                    root.connectionType = "eth";
                }
            }
        }
    }

    // Network monitor
    Process {
        id: netProc
        command: ["sh", "-c", "interface=$(ip route | grep default | awk '{print $5}' | head -1); echo $interface; ip -4 addr show $interface 2>/dev/null | grep inet | awk '{print $2}' | cut -d/ -f1 || echo '...'; while true; do cat /proc/net/dev | grep $interface | awk '{print $2, $10}'; sleep 1; done"]
        running: true

        property int lineNum: 0
        property real lastRx: 0
        property real lastTx: 0

        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                if (trimmed === "")
                    return;

                if (netProc.lineNum === 0) {
                    // First line is interface name
                    root.interfaceName = trimmed;
                    if (root.networkName === "...") {
                        root.networkName = trimmed;
                    }
                    netProc.lineNum++;
                } else if (netProc.lineNum === 1) {
                    // Second line is IP address
                    root.ipAddress = trimmed;
                    netProc.lineNum++;
                } else {
                    // Traffic data
                    var parts = trimmed.split(/\s+/);
                    if (parts.length >= 2) {
                        var rx = parseFloat(parts[0]);
                        var tx = parseFloat(parts[1]);

                        if (netProc.lastRx > 0) {
                            root.downloadSpeed = rx - netProc.lastRx;
                            root.uploadSpeed = tx - netProc.lastTx;

                            // Add to history for graph
                            var total = root.downloadSpeed + root.uploadSpeed;
                            root.trafficHistory.unshift(total);
                            if (root.trafficHistory.length > 20) {
                                root.trafficHistory.pop();
                            }
                        }

                        netProc.lastRx = rx;
                        netProc.lastTx = tx;
                    }
                }
            }
        }
    }
}
