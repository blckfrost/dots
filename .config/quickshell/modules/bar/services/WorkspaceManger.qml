pragma Singleton

import QtQuick
import Quickshell

import qs.shared.config
import qs.modules.bar.services

Singleton {
    id: manager

    property var _handler

    property int selectedWorkspaceId
    property var workspaceStates: ({})

    function isWorkspaceOccupied(workspaceId) {
        const state = manager.workspaceStates[workspaceId];
        return state ? state.occupied === true : false;
    }

    function isWorkspaceUrgent(workspaceId) {
        const state = manager.workspaceStates[workspaceId];
        return state ? state.urgent === true : false;
    }

    function switchToWorkspaceId(workspaceId) {
        if (!manager._handler) {
            return;
        }
        manager._handler.switchToWorkspaceId(workspaceId);
    }

    function cycleWorkspace(step) {
        if (!manager._handler) {
            return;
        }
        manager._handler.cycleWorkspace(step);
    }

    Component.onCompleted: {
        if (Desktop.compositor === Desktop.Compositor.Hyprland) {
            _handler = HyprlandHandler;
        } else {
            throw new Error("Compositor not supported.");
        }

        manager.selectedWorkspaceId = _handler.selectedWorkspaceId;
        manager.workspaceStates = _handler.workspaceStates;
    }

    Connections {
        target: manager._handler
        function onSelectedWorkspaceIdChanged() {
            debounceTimer.restart();
        }
        function onWorkspaceStatesChanged() {
            manager.workspaceStates = manager._handler.workspaceStates;
        }
    }

    Timer {
        id: debounceTimer
        interval: 10
        onTriggered: manager.selectedWorkspaceId = manager._handler.selectedWorkspaceId
    }
}
