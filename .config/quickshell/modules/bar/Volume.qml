import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.shared

Item {
    id: root

    property int speakerVolume: 0
    property bool speakerMuted: false
    property int micVolume: 0
    property bool micMuted: false

    height: parent.height
    width: frame.implicitWidth + 6

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 8

            // Speaker/Output Volume
            Item {
                width: volRow.width
                height: volRow.height

                Row {
                    id: volRow
                    spacing: 4

                    Text {
                        text: "VOL"
                        color: Theme.textPrimaryDim
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }

                    Text {
                        text: root.speakerMuted ? "XXX" : root.speakerVolume.toString()
                        color: root.speakerMuted ? Theme.accentRed : Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.RightButton

                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            speakerMuteProc.running = true;
                        }
                    }

                    onWheel: (wheel) => {
                        var delta = wheel.angleDelta.y > 0 ? 5 : -5;
                        var newVolume = Math.max(0, Math.min(100, root.speakerVolume + delta));
                        speakerVolumeProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (newVolume / 100.0).toFixed(2)];
                        speakerVolumeProc.running = true;
                    }
                }
            }

            // Microphone/Input Volume
            Item {
                width: micRow.width
                height: micRow.height

                Row {
                    id: micRow
                    spacing: 4

                    Text {
                        text: "MIC"
                        color: Theme.textPrimaryDim
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }

                    Text {
                        text: root.micMuted ? "XXX" : root.micVolume.toString()
                        color: root.micMuted ? Theme.accentRed : Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.RightButton

                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            micMuteProc.running = true;
                        }
                    }

                    onWheel: (wheel) => {
                        var delta = wheel.angleDelta.y > 0 ? 5 : -5;
                        var newVolume = Math.max(0, Math.min(100, root.micVolume + delta));
                        micVolumeProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", (newVolume / 100.0).toFixed(2)];
                        micVolumeProc.running = true;
                    }
                }
            }
        }
    }

    // Helper processes for volume control
    Process {
        id: speakerMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        running: false
    }

    Process {
        id: speakerVolumeProc
        command: []
        running: false
    }

    Process {
        id: micMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]
        running: false
    }

    Process {
        id: micVolumeProc
        command: []
        running: false
    }

    // Volume monitor using wpctl (PipeWire) - works with all audio devices
    Process {
        id: volumeProc
        command: ["sh", "-c", "while true; do wpctl get-volume @DEFAULT_AUDIO_SINK@ && wpctl get-volume @DEFAULT_AUDIO_SOURCE@; sleep 1; done"]
        running: true

        property int lineCount: 0

        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                if (trimmed === "") {
                    return;
                }

                // wpctl output format: "Volume: 0.65" or "Volume: 0.65 [MUTED]"
                var parts = trimmed.split(/\s+/);
                if (parts.length >= 2 && parts[0] === "Volume:") {
                    var volume = Math.round(parseFloat(parts[1]) * 100);
                    var muted = trimmed.includes("[MUTED]");

                    if (volumeProc.lineCount % 2 === 0) {
                        // Even lines = speaker/sink
                        root.speakerVolume = volume;
                        root.speakerMuted = muted;
                    } else {
                        // Odd lines = mic/source
                        root.micVolume = volume;
                        root.micMuted = muted;
                    }

                    volumeProc.lineCount++;
                }
            }
        }
    }
}
