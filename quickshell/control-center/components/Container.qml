import QtQuick
import QtQuick.Layoutscontainer
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls

import "../config.js" as Config

Rectangle {
    id: root

    PanelWindow {

        id: panel
        property bool expanded: false
        readonly property int collapseDelay: 100
        readonly property int minHeight: 36
        readonly property int maxWidth: 1024
        readonly property int maxHeight: 1024

        color: "transparent"
        exclusiveZone: minHeight
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell:panel"
        anchors { top: true }

        // Fixed surface size — never animated. This is what removes the lag.
        implicitHeight: maxHeight
        implicitWidth: maxWidth

        // Only let clicks land on the actually-visible pill/panel area.
        mask: Region { item: bg }

        Timer {
            id: collapseTimer
            interval: panel.collapseDelay
            onTriggered: panel.expanded = false
        }
        Rectangle {
            id: bg
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: panel.expanded ? Math.min(panel.maxWidth, 400) : pill.implicitWidth + 36

            property int expectedHeight: panel.expanded ? Math.min(panel.maxHeight, content.implicitHeight + 36) : panel.minHeight
            height: Hyprland.focusedWorkspace?.hasFullscreen ? 0 : expectedHeight

            opacity: Hyprland.focusedWorkspace?.hasFullscreen ? 0 : 1

            bottomRightRadius: panel.expanded ? 18 : 17
            bottomLeftRadius: panel.expanded ? 18 : 17
            color: Config.colors.bg0

            Behavior on width  { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
            Behavior on height { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
            Behavior on bottomRightRadius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
            Behavior on bottomLeftRadius  { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            RowLayout {
                id: pill
                anchors.centerIn: parent
                visible: !panel.expanded
                opacity: panel.expanded ? 0 : 1
                spacing: 10
                Behavior on opacity { NumberAnimation { duration: 50 } }
                Text {
                    text: Qt.formatTime(clock.date, "hh:mm")
                    font.pointSize: 13
                    color: Config.colors.fg0
                }
            }

            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: 16
                visible: opacity > 0
                opacity: panel.expanded ? 1 : 0
                spacing: 14
                Behavior on opacity { NumberAnimation { duration: 50 } }

                Text {
                    text: Qt.formatDateTime(clock.date, "dddd, MMMM d - hh:mm:ss")
                    color: Config.colors.fg0
                    font.pointSize: 12
                    Layout.fillWidth: true
                }

                AudioSlider{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            HoverHandler {
                id: hoverHandler
                onHoveredChanged: {
                    if (hovered) {
                        collapseTimer.stop()
                        panel.expanded = true
                    } else {
                        collapseTimer.restart()
                    }
                }
            }

        }

        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }

    }

}
