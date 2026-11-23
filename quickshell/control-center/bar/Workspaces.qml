import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls

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

    anchors { top: true; left: true }
    mask: Region { item: root }

    RowLayout {
        id: root
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 5

        opacity: !Hyprland.focusedWorkspace?.hasFullscreen ? 1 : 0
        visible: opacity > 0
        enabled: opacity > 0

        Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

        Repeater {
            model: Hyprland.workspaces.values.filter(workspace => workspace.id > 0)
            delegate: workspace
        }
    }

    Component {
        id: workspace
        Rectangle {
            required property HyprlandWorkspace modelData
            required property int index
            readonly property double padding: 5
            readonly property color textColor: modelData.active ? Config.colors.bg0 :Config.colors.fg0
            readonly property color bgColor: modelData.active ? Config.colors.fg0 :Config.colors.bg0

            color: bgColor

            property real side: Math.max(text.implicitWidth, text.implicitHeight)

            implicitHeight: side + padding
            implicitWidth: side + padding
            radius: 6

            Behavior on implicitHeight { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            StyledText {
                id: text
                anchors.centerIn: parent
                text: modelData.id
                color: textColor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: (mouse) => {
                    Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData.id} })`)
                }
            }
        }
    }
}
