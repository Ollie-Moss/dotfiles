import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Networking

import "../config.js" as Config
import "../components"
import "../bar"

ColumnLayout {
    spacing: 10

    // Single wired device
    Repeater {
        model: Networking.devices.values
        .filter(d => d.type === DeviceType.Wired)
        .slice(0, 1)
        delegate: wiredDevice
    }

    // Single wifi device
    Repeater {
        model: Networking.devices.values
        .filter(d => d.type === DeviceType.Wifi)
        .slice(0, 1)
        delegate: wifiDevice
    }

    // ───────────────────────── Ethernet ─────────────────────────
    Component {
        id: wiredDevice
        ColumnLayout {
            id: wiredRoot
            required property WiredDevice modelData

            readonly property bool connected: modelData.connected
            readonly property color iconColor: connected
            ? Config.colors.fg0
            : Qt.alpha(Config.colors.fg0, 0.5)

            Layout.fillWidth: true
            spacing: 4

            StyledText { text: "Ethernet"; opacity: 0.6 }

            Rectangle {
                Layout.fillWidth: true
                implicitWidth: wiredRow.implicitWidth + 16
                implicitHeight: 28
                radius: 6
                color: wiredRoot.connected
                ? Qt.alpha(Config.colors.fg0, 0.14)
                : wiredArea.containsMouse
                ? Qt.alpha(Config.colors.fg0, 0.07)
                : "transparent"

                RowLayout {
                    id: wiredRow
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Icon {
                        Layout.alignment: Qt.AlignVCenter
                        size: 18
                        path: wiredRoot.connected
                        ? "../icons/ethernet-connected"
                        : "../icons/ethernet-disconnected"
                        color: wiredRoot.iconColor
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: wiredRoot.modelData.name
                    }

                    StyledText {
                        text: ConnectionState.toString(wiredRoot.modelData.state)
                        opacity: 0.7
                    }
                }

                MouseArea {
                    id: wiredArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        const dev = wiredRoot.modelData
                        if (dev.connected) dev.disconnect()
                        else dev.autoconnect = true
                    }
                }
            }
        }
    }

    // ────────────────────────── Wifi ────────────────────────────
    Component {
        id: wifiDevice
        ColumnLayout {
            id: wifiRoot
            required property WifiDevice modelData

            property bool expanded: false

            // Everything except the active network, sorted by bars then name
            // (quantized so rows don't reshuffle on every tiny RSSI change)
            readonly property var otherNetworks: modelData.networks.values
            .filter(n => !(n.connected || n.state === ConnectionState.Connecting))
            .sort((a, b) =>
                (Math.round(b.signalStrength * 4) - Math.round(a.signalStrength * 4))
                || a.name.localeCompare(b.name))

            Layout.fillWidth: true
            spacing: 4

            Binding {
                target: wifiRoot.modelData
                property: "scannerEnabled"
                value: wifiRoot.expanded
            }

            StyledText { text: "Wifi"; opacity: 0.6 }

            // Active (connected / connecting) network
            Repeater {
                id: activeRepeater
                model: wifiRoot.modelData.networks.values
                .filter(n => n.connected || n.state === ConnectionState.Connecting)
                .slice(0, 1)
                delegate: wifiNetwork
            }

            StyledText {
                visible: activeRepeater.count === 0
                text: "Not connected"
                opacity: 0.5
            }

            // "Other networks" header
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 28
                radius: 6
                color: headerArea.containsMouse
                ? Qt.alpha(Config.colors.fg0, 0.07)
                : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    StyledText {
                        Layout.fillWidth: true
                        text: "Other networks"
                    }
                    StyledText {
                        text: wifiRoot.expanded ? "▴" : "▾"
                        opacity: 0.7
                    }
                }

                MouseArea {
                    id: headerArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: wifiRoot.expanded = !wifiRoot.expanded
                }
            }

            StyledText {
                visible: wifiRoot.otherNetworks.length < 1 && wifiRoot.expanded
                text: "Searching for networks..."
                leftPadding: 8
            }

            // Dropdown: max 5 rows visible, scrolls beyond that
            ListView {
                id: otherList

                readonly property int rowHeight: 28
                readonly property int maxVisible: 5
                readonly property real maxHeight: maxVisible * rowHeight + (maxVisible - 1) * spacing

                Layout.fillWidth: true
                implicitWidth: 260   // floor width; adjust to match the rest of your panel
                Layout.preferredHeight: wifiRoot.expanded
                ? Math.min(contentHeight, maxHeight)
                : 0
                Behavior on Layout.preferredHeight {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                visible: Layout.preferredHeight > 0
                clip: true
                spacing: 4
                interactive: contentHeight > height
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle {
                        implicitWidth: 3
                        radius: 1.5
                        color: Qt.alpha(Config.colors.fg0, 0.35)
                    }
                    background: Item {}
                }

                // ScriptModel diffs the list, so delegates (and any half-typed
                // password) survive re-sorts and scan updates.
                model: ScriptModel { values: wifiRoot.otherNetworks }
                delegate: wifiNetwork

                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 }
                }
                remove: Transition {
                    NumberAnimation { property: "opacity"; to: 0; duration: 100 }
                }
                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 150; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    // ───────────────────── Single wifi network row ─────────────────────
    Component {
        id: wifiNetwork
        ColumnLayout {
            id: netRoot
            required property WifiNetwork modelData

            property bool askingPassword: false

            readonly property bool active: modelData.connected
            || modelData.state === ConnectionState.Connecting
            readonly property bool needsPsk: [
            WifiSecurityType.WpaPsk,
            WifiSecurityType.Wpa2Psk,
            WifiSecurityType.Sae
            ].includes(modelData.security)

            // Connected to the AP, but the host can't reach the internet.
            // Unknown means checks are disabled/not run yet, so don't treat it as a failure.
            readonly property bool noInternet: modelData.connected
            && Networking.connectivity !== NetworkConnectivity.Full
            && Networking.connectivity !== NetworkConnectivity.Unknown

            // signalStrength is 0.0–1.0, map to 0–4 bars
            readonly property int bars: Math.max(0, Math.min(4, Math.round(modelData.signalStrength * 4)))

            readonly property string iconPath: noInternet
            ? "../icons/wifi_disconnected.svg"
            : netRoot.modelData.security !== WifiSecurityType.Open
            ? "../icons/wifi_" + bars + "_bar_locked.svg"
            : "../icons/wifi_" + bars + "_bar.svg"

            // Works both inside a ListView (needs explicit width) and a layout/Repeater
            width: ListView.view ? ListView.view.width : implicitWidth
            Layout.fillWidth: true
            spacing: 4

            function submitPsk(psk) {
                modelData.connectWithPsk(psk)
                pskField.text = ""
                askingPassword = false
            }

            // If connect() fails because there's no saved secret, prompt for one
            Connections {
                target: netRoot.modelData
                function onConnectionFailed(reason) {
                    if (reason === ConnectionFailReason.NoSecrets && netRoot.needsPsk)
                    netRoot.askingPassword = true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitWidth: rowContent.implicitWidth + 16
                implicitHeight: 28
                radius: 6
                color: netRoot.active
                ? Qt.alpha(Config.colors.fg0, 0.14)
                : rowArea.containsMouse
                ? Qt.alpha(Config.colors.fg0, 0.07)
                : "transparent"

                RowLayout {
                    id: rowContent
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Icon {
                        Layout.alignment: Qt.AlignVCenter
                        size: 18
                        path: netRoot.iconPath
                        color: netRoot.active
                        ? Config.colors.fg0
                        : Qt.alpha(Config.colors.fg0, 0.7)
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: netRoot.modelData.name
                    }

                    StyledText {
                        visible: netRoot.active
                        text: netRoot.noInternet
                        ? "No internet"
                        : ConnectionState.toString(netRoot.modelData.state)
                        opacity: 0.7
                    }
                }

                MouseArea {
                    id: rowArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: (mouse) => {
                        const net = netRoot.modelData
                        if (mouse.button === Qt.RightButton) {
                            if (net.known) net.forget()
                        } else if (netRoot.active) {
                            net.disconnect()
                        } else if (!net.known && netRoot.needsPsk) {
                            netRoot.askingPassword = !netRoot.askingPassword
                        } else {
                            net.connect()
                        }
                    }
                }
            }

            // Password prompt for unsaved secured networks (height-animated)
            Item {
                Layout.fillWidth: true
                implicitHeight: netRoot.askingPassword ? 30 : 0
                visible: implicitHeight > 0
                clip: true
                Behavior on implicitHeight {
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }

                TextField {
                    id: pskField
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    echoMode: TextInput.Password
                    placeholderText: "Password"
                    color: Config.colors.fg0
                    placeholderTextColor: Qt.alpha(Config.colors.fg0, 0.5)
                    background: Rectangle {
                        radius: 4
                        color: Qt.alpha(Config.colors.fg0, 0.08)
                    }
                    onVisibleChanged: if (visible) forceActiveFocus()
                    onAccepted: if (text.length > 0) netRoot.submitPsk(text)
                    Keys.onEscapePressed: {
                        text = ""
                        netRoot.askingPassword = false
                    }
                }
            }
        }
    }
}
