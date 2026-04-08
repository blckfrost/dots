import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.shared

// qmllint disable
PanelWindow {
    id: root

    color: Qt.rgba(0.149, 0.149, 0.149, 0.6)
    focusable: true

    implicitHeight: 28

    anchors {
        top: true
        right: true
        left: true
    }
    WlrLayershell.layer: WlrLayer.Top

    Rectangle {
        anchors.fill: parent
        border {
            width: 0
            color: Theme.frostyGray
        }
        color: "transparent"
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Row {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            spacing: 4

            Hostname {}

            StatusCode {}

            Workspaces {}
        }

        Item {
            Layout.fillWidth: true
        }

        Row {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            spacing: 4

            Network {
                window: root
            }

            HexDisplay {}

            Volume {}

            Meter {
                id: cpuMeter
                name: "CPU"
                value: "0%"
                percentage: 0

                property real lastCpuTotal: 0
                property real lastCpuIdle: 0

                Process {
                    id: cpuProc
                    command: ["sh", "-c", "while true; do head -1 /proc/stat; sleep 2; done"]
                    running: true

                    stdout: SplitParser {
                        onRead: data => {
                            var parts = data.trim().split(/\s+/);
                            if (parts.length >= 5) {
                                var user = parseFloat(parts[1]);
                                var nice = parseFloat(parts[2]);
                                var system = parseFloat(parts[3]);
                                var idle = parseFloat(parts[4]);
                                var iowait = parseFloat(parts[5]) || 0;
                                var irq = parseFloat(parts[6]) || 0;
                                var softirq = parseFloat(parts[7]) || 0;

                                var total = user + nice + system + idle + iowait + irq + softirq;

                                if (cpuMeter.lastCpuTotal > 0) {
                                    var totalDiff = total - cpuMeter.lastCpuTotal;
                                    var idleDiff = idle - cpuMeter.lastCpuIdle;
                                    var usagePercent = ((totalDiff - idleDiff) / totalDiff) * 100;

                                    cpuMeter.percentage = Math.round(usagePercent);
                                    cpuMeter.value = Math.round(usagePercent) + "%";
                                }

                                cpuMeter.lastCpuTotal = total;
                                cpuMeter.lastCpuIdle = idle;
                            }
                        }
                    }
                }
            }

            Meter {
                id: memMeter
                name: "MEM"
                value: "0%"
                percentage: 0

                Process {
                    id: memProc
                    command: ["sh", "-c", "while true; do free -m | awk '/^Mem:/ {print $2, $3}'; sleep 2; done"]
                    running: true

                    stdout: SplitParser {
                        onRead: data => {
                            var parts = data.trim().split(/\s+/);
                            if (parts.length >= 2) {
                                var total = parseFloat(parts[0]);
                                var used = parseFloat(parts[1]);
                                var usagePercent = (used / total) * 100;

                                memMeter.percentage = Math.round(usagePercent);
                                memMeter.value = Math.round(usagePercent) + "%";
                            }
                        }
                    }
                }
            }

            Battery {}

            Clock {}
        }
    }
}
