//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import qs.shared

Item {
    id: root

    required property var window

    readonly property var trayItems: SystemTray.items && SystemTray.items.values ? SystemTray.items.values : []

    visible: trayItems.length > 0
    height: parent.height
    width: visible ? frame.implicitWidth + 6 : 0

    CornerFrame {
        id: frame
        anchors.centerIn: parent
        height: parent.height - 4

        Row {
            spacing: 2

            Repeater {
                model: ScriptModel {
                    values: root.trayItems
                }

                delegate: MouseArea {
                    id: trayItem

                    required property SystemTrayItem modelData

                    width: 16
                    height: 16
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: event => {
                        if (event.button === Qt.LeftButton) {
                            modelData.activate();
                        } else if (event.button === Qt.MiddleButton) {
                            if (modelData.secondaryActivate) {
                                modelData.secondaryActivate();
                            }
                        } else if (event.button === Qt.RightButton && modelData.hasMenu && modelData.menu) {
                            menuAnchor.open();
                        }

                        event.accepted = true;
                    }

                    onWheel: event => {
                        if (modelData.scroll) {
                            var points = event.angleDelta.y / 120;
                            modelData.scroll(points, false);
                        }

                        event.accepted = true;
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 2
                        color: trayItem.containsMouse ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
                    }

                    IconImage {
                        anchors.centerIn: parent
                        source: trayItem.modelData.icon
                        implicitSize: 14
                    }

                    QsMenuAnchor {
                        id: menuAnchor
                        menu: trayItem.modelData.menu

                        anchor.window: root.window
                        anchor.adjustment: PopupAdjustment.Flip

                        anchor.onAnchoring: {
                            var widgetRect = root.window.contentItem.mapFromItem(trayItem, 0, trayItem.height, trayItem.width, trayItem.height);
                            menuAnchor.anchor.rect = widgetRect;
                        }
                    }
                }
            }
        }
    }
}
