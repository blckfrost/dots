pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root

    property int selectedWorkspaceId: Hyprland.focusedWorkspace.id
    property var workspaceStates: ({})

    function switchToWorkspaceId(workspaceId) {
        if (workspaceId < 1) {
            return;
        }
        dispatchProc.command = ["hyprctl", "dispatch", "workspace", workspaceId.toString()];
        dispatchProc.running = true;
    }

    function cycleWorkspace(step) {
        if (step === 0) {
            return;
        }
        dispatchProc.command = ["hyprctl", "dispatch", "workspace", step > 0 ? "+1" : "-1"];
        dispatchProc.running = true;
    }

    function updateWorkspaceStates(workspacesJson, clientsJson) {
        let workspaces = [];
        let clients = [];

        try {
            workspaces = JSON.parse(workspacesJson);
        } catch (e) {
            workspaces = [];
        }

        try {
            clients = JSON.parse(clientsJson);
        } catch (e) {
            clients = [];
        }

        const nextStates = {};
        for (const workspace of workspaces) {
            const workspaceId = Number(workspace.id || 0);
            if (workspaceId < 1) {
                continue;
            }

            nextStates[workspaceId] = {
                occupied: Number(workspace.windows || 0) > 0,
                urgent: false
            };
        }

        for (const client of clients) {
            const workspaceId = client && client.workspace ? Number(client.workspace.id || 0) : 0;
            if (workspaceId < 1) {
                continue;
            }

            if (!nextStates[workspaceId]) {
                nextStates[workspaceId] = {
                    occupied: false,
                    urgent: false
                };
            }

            nextStates[workspaceId].occupied = true;
            if (client.urgent === true) {
                nextStates[workspaceId].urgent = true;
            }
        }

        workspaceStates = nextStates;
    }

    Process {
        id: dispatchProc
        command: []
        running: false
    }

    Process {
        id: stateProc
        command: ["sh", "-c", "while true; do hyprctl -j workspaces 2>/dev/null || echo '[]'; echo __QS_WS_STATE_SPLIT__; hyprctl -j clients 2>/dev/null || echo '[]'; echo __QS_WS_STATE_END__; sleep 1; done"]
        running: true

        property string workspacesJson: "[]"
        property string clientsJson: "[]"
        property bool readingClients: false

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (line === "") {
                    return;
                }

                if (line === "__QS_WS_STATE_SPLIT__") {
                    stateProc.readingClients = true;
                    return;
                }

                if (line === "__QS_WS_STATE_END__") {
                    root.updateWorkspaceStates(stateProc.workspacesJson, stateProc.clientsJson);
                    stateProc.readingClients = false;
                    return;
                }

                if (stateProc.readingClients) {
                    stateProc.clientsJson = line;
                } else {
                    stateProc.workspacesJson = line;
                }
            }
        }
    }
}
