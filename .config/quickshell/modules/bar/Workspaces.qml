pragma ComponentBehavior: Bound
import QtQuick

import "services"

Row {
    id: root

    property int count: 5

    width: parent.height * count + (count - 1)
    height: parent.height

    Repeater {
        model: root.count

        Row {
            required property int index
            readonly property int workspaceId: index + 1

            height: parent.height
            Workspace {
                id: workspace
                workspaceId: parent.workspaceId
                active: parent.workspaceId === WorkspaceManger.selectedWorkspaceId
                occupied: WorkspaceManger.isWorkspaceOccupied(parent.workspaceId)
                urgent: WorkspaceManger.isWorkspaceUrgent(parent.workspaceId)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            WorkspaceManger.switchToWorkspaceId(workspace.workspaceId);
                        }
                    }

                    onWheel: wheel => {
                        WorkspaceManger.cycleWorkspace(wheel.angleDelta.y > 0 ? 1 : -1);
                    }
                }
            }
        }
    }
}
