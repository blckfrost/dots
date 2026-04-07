import QtQuick
import Quickshell

import qs.shared

Rectangle {
    anchors {
        // accounting for 1 pixel border on bar
        top: parent.top
        topMargin: 1
        bottom: parent.bottom
        bottomMargin: 1
    }
    width: 1
    color: Theme.layer2
}
