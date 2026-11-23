import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick.Controls

import "../config.js" as Config
import "../components"

RowLayout {
    id: root
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 5

    opacity: !Hyprland.focusedWorkspace?.hasFullscreen ? 1 : 0
    visible: opacity > 0
    enabled: opacity > 0

}

