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
    property bool isConnected: false
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
                text: root.isConnected ? root.networkName : "OFFLINE"
                color: root.isConnected ? Theme.textPrimary : Theme.accentRed
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
        }
        onExited: {
            networkTooltip.visible = false;
        }
    }

    // Tooltip as PopupWindow
    PopupWindow {
        id: networkTooltip
        visible: root.showTooltip

        anchor {
            window: root.window
            rect.x: root.mapToItem(root.window, root.width / 2 - tooltipContent.width / 2, root.height).x
            rect.y: root.mapToItem(root.window, 0, root.height).y
            rect.width: tooltipContent.width
            rect.height: 1

            edges: Edges.Bottom | Edges.CenterH
            gravity: Edges.Top | Edges.CenterH
            adjustment: PopupAdjustment.Flip | PopupAdjustment.SlideY
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
                    text: "┌─[ " + (root.isConnected ? "NETWORK" : "OFFLINE") + " ]─────────────────"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                Text {
                    text: "│ Network: " + (root.isConnected ? root.networkName : "NO NETWORK")
                    color: root.isConnected ? Theme.textPrimary : Theme.accentRed
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
                    color: root.isConnected ? Theme.textAccent : Theme.textPrimaryDim
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

    // Network monitor
    Process {
        id: netProc
        command: ["sh", "-c", "while true; do interface=$(ip route 2>/dev/null | awk '/^default/ {print $5; exit}'); if [ -n \"$interface\" ]; then ipaddr=$(ip -4 addr show \"$interface\" 2>/dev/null | awk '/inet / {print $2; exit}' | cut -d/ -f1); rx_tx=$(awk -v dev=\"$interface:\" '$1==dev {print $2\" \"$10; exit}' /proc/net/dev); rx=$(printf '%s' \"$rx_tx\" | awk '{print $1}'); tx=$(printf '%s' \"$rx_tx\" | awk '{print $2}'); case \"$interface\" in wl*|wlan*) ctype='wifi' ;; *) ctype='eth' ;; esac; if [ \"$ctype\" = 'wifi' ]; then ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1==\"yes\" {print $2; exit}'); if [ -z \"$ssid\" ]; then ssid=$(iwgetid -r 2>/dev/null); fi; name=${ssid:-WiFi}; else name='Wired'; fi; echo \"STATE|1|$interface|${ipaddr:-...}|$ctype|$name|${rx:-0}|${tx:-0}\"; else echo 'STATE|0|...|...|none|NO NETWORK|0|0'; fi; sleep 1; done"]
        running: true

        property string lastInterface: ""
        property real lastRx: 0
        property real lastTx: 0

        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                if (trimmed === "")
                    return;

                if (!trimmed.startsWith("STATE|"))
                    return;

                var parts = trimmed.split("|");
                if (parts.length < 8)
                    return;

                root.isConnected = parts[1] === "1";

                if (!root.isConnected) {
                    root.interfaceName = "...";
                    root.networkName = "NO NETWORK";
                    root.connectionType = "none";
                    root.ipAddress = "...";
                    root.uploadSpeed = 0;
                    root.downloadSpeed = 0;
                    root.trafficHistory = [];
                    netProc.lastInterface = "";
                    netProc.lastRx = 0;
                    netProc.lastTx = 0;
                    return;
                }

                root.interfaceName = parts[2] || "...";
                root.ipAddress = parts[3] || "...";
                root.connectionType = parts[4] || "eth";
                root.networkName = parts[5] || root.interfaceName;

                var rx = parseFloat(parts[6]) || 0;
                var tx = parseFloat(parts[7]) || 0;

                if (netProc.lastInterface !== root.interfaceName) {
                    netProc.lastInterface = root.interfaceName;
                    netProc.lastRx = rx;
                    netProc.lastTx = tx;
                    root.uploadSpeed = 0;
                    root.downloadSpeed = 0;
                    return;
                }

                if (netProc.lastRx > 0) {
                    root.downloadSpeed = Math.max(0, rx - netProc.lastRx);
                    root.uploadSpeed = Math.max(0, tx - netProc.lastTx);

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
