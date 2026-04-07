import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import qs.shared

// qmllint disable
PanelWindow {
    id: root

    color: Theme.background
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
            color: Theme.ctosGray
        }
        color: "transparent"
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Row {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            Workspaces {}
        }
    }
}
