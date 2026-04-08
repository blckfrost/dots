import QtQuick
import qs.shared

Item {
    id: root

    property bool active: true

    height: parent.height
    width: parent.height

    CornerFrame {
        anchors.centerIn: parent
        width: parent.height - 6
        height: parent.height - 6
    }

    Item {
        anchors.centerIn: parent
        opacity: root.active ? 1 : 0

        Rectangle {
            width: 9
            height: 1
            color: Theme.frostyGray
            anchors.centerIn: parent
        }

        Rectangle {
            width: 1
            height: 9
            color: Theme.frostyGray
            anchors.centerIn: parent
        }
    }
}
