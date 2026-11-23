import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Services.SystemTray

import "root:/services"

import "../config.js" as Config
import "../components"

PanelWindow {
    color: "transparent"
    exclusiveZone: -1
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "quickshell:panel"

    implicitWidth: 500
    implicitHeight: 1000

    anchors { top: true; right: true }
    mask: Region { item: root }

    Row{
        id: root
        anchors.right: parent.right
        anchors.top: parent.top

        ExpandablePanel {
            id: panel
            boxWidth: 36
            boxHeight: 36
            padding: 12

            defaultItem: Rectangle {
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    source: "../icons/power.svg"
                }
            }

            TapHandler {
                onTapped: panel.openWith(powerMenu)
            }
        }

        Component {
            id: powerMenu
            RowLayout {
                spacing: 10
                Rectangle {
                    color: Config.colors.error

                    readonly property double padding: 5
                    implicitHeight: shutdownIcona.size + padding
                    implicitWidth: shutdownIcona.size + padding

                    radius: 10
                    Icon {
                        id: shutdownIcona
                        anchors.centerIn: parent
                        path: "../icons/power.svg"
                        color: Config.colors.bg2
                        size: 50
                    }

                    TapHandler {
                        onTapped: () => {
                            Quickshell.execDetached(["systemctl", "poweroff"]);
                        }
                    }
                }
                Rectangle {
                    color: Config.colors.fg0

                    readonly property double padding: 5
                    implicitHeight: restartIcona.size + padding
                    implicitWidth: restartIcona.size + padding

                    radius: 10
                    Icon {
                        id: restartIcona
                        anchors.centerIn: parent
                        path: "../icons/restart.svg"
                        color: Config.colors.bg0
                        size: 50
                    }

                    TapHandler {
                        onTapped: () => {
                            Quickshell.execDetached(["systemctl", "reboot"]);
                        }
                    }
                }

            }
        }

    }
}
