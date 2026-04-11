import QtQuick
import qs.shared

Item {
    id: root

    property int workspaceId: 1
    property bool active: false
    property bool occupied: false
    property bool urgent: false

    readonly property color frameColor: urgent ? Theme.error : (active ? Theme.textAccent : (occupied ? Theme.textPrimaryDim : Theme.secondary))
    readonly property color centerColor: urgent ? Theme.error : Theme.frostyGray

    height: parent.height
    width: parent.height

    CornerFrame {
        anchors.centerIn: parent
        width: parent.height - 6
        height: parent.height - 6
        accentColor: root.frameColor
    }

    Item {
        anchors.centerIn: parent
        width: 9
        height: 9
        opacity: root.active || root.occupied || root.urgent ? 1 : 0

        Rectangle {
            width: 9
            height: 1
            visible: root.active
            color: root.centerColor
            anchors.centerIn: parent
        }

        Rectangle {
            width: 1
            height: 9
            visible: root.active
            color: root.centerColor
            anchors.centerIn: parent
        }

        Rectangle {
            width: 3
            height: 3
            radius: 1
            visible: !root.active && root.occupied
            color: Theme.textPrimaryDim
            anchors.centerIn: parent
        }
    }
}
