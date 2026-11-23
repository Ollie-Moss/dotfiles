//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls

import "config.js" as Config
import "components"
import "bar"

Scope {
    Workspaces {}
    Time {}
    Power {}
}
