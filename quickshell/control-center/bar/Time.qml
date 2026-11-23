import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Services.SystemTray

import "../config.js" as Config
import "../components"
import "root:/services"

PanelWindow {
    color: "transparent"
    exclusiveZone: 36
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "quickshell:panel"
    anchors { top: true }
    implicitWidth: 500
    implicitHeight: 1000

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    mask: Region { item: root }

    ExpandablePanel {
        id: root
        anchors.horizontalCenter: parent.horizontalCenter
        boxWidth: 100
        boxHeight: 36
        padding: 6

        defaultItem: Component {
            id: time
            Item {
                CenteredText {
                    // anchors.fill: parent
                    text: Qt.formatTime(clock.date, "hh:mm")
                }
            }
        }

        HoverHandler {
            onHoveredChanged: if(hovered) root.openWith(controlPanel)
        }

        Connections {
            target: Bus
            function onOpenCenterMenu(comp) {
                root.openWith(comp)
            }
        }
    }

    Component {
        id: controlPanel
        ColumnLayout {
            id: content
            Behavior on opacity { NumberAnimation { duration: 50 } }

            StyledText {
                // Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                text: Qt.formatDateTime(clock.date, "dddd, MMMM d - hh:mm:ss")
            }

            // ---- System tray ----
            Rectangle {
                id: tray
                visible: SystemTray.items.values.length > 0

                readonly property real iconSize: 18
                readonly property real padding: 5

                color: "transparent"
                radius: 6
                Layout.fillWidth: true
                implicitHeight: trayRow.implicitHeight

                RowLayout {
                    id: trayRow
                    spacing: 6

                    Repeater {
                        model: SystemTray.items
                        delegate: trayItem
                    }
                }

                Component {
                    id: trayItem
                    MouseArea {
                        id: area
                        required property SystemTrayItem modelData

                        implicitWidth: tray.iconSize
                        implicitHeight: tray.iconSize
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                        hoverEnabled: true

                        function openMenu() {
                            const pos = mapToItem(null, 0, height + 4)
                            modelData.display(QsWindow.window, pos.x, pos.y)
                        }

                        onClicked: (mouse) => {
                            if (mouse.button === Qt.LeftButton) {
                                if (modelData.onlyMenu && modelData.hasMenu) openMenu()
                                else modelData.activate()
                            } else if (mouse.button === Qt.MiddleButton) {
                                modelData.secondaryActivate()
                            } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                                openMenu()
                            }
                        }

                        onWheel: (wheel) => modelData.scroll(wheel.angleDelta.y, false)

                        Icon {
                            size: tray.iconSize
                            path: area.modelData.icon
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                        }
                    }
                }

            }
            AudioSlider{
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Network {}

        }
    }

}
