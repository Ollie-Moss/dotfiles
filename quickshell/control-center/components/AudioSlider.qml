import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls

import "../config.js" as Config

Pane {
    background: Rectangle {
        color:"transparent"
        MouseArea {
            anchors.fill: parent
            hoverEnabled: false
            acceptedButtons: Qt.NoButton

            onWheel: (wheel) => {
                if (Pipewire.defaultAudioSink?.audio == null) return;
                var multiplier = 5
                var normalizedScroll = wheel.angleDelta.y / 120
                var distance = normalizedScroll / 100

                if(wheel.modifiers & Qt.ShiftModifier){
                    distance *= multiplier
                }

                Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, Pipewire.defaultAudioSink.audio.volume + distance))

                if (hoverHandler.hovered === false){
                    slider.shouldShow = true
                    collapseTimer.interval = 500
                    collapseTimer.restart()
                }

                wheel.accepted = true
            }
        }
    }
    RowLayout {
        anchors.fill: parent
        Image {
            width: 30
            source: "../icons/volume_muted.svg"
        }

        Slider {
            Timer {
                id: collapseTimer
                readonly property int defaultInterval: 100
                interval: defaultInterval
                onTriggered: () => {
                    interval = defaultInterval
                    slider.shouldShow = false
                }
            }
            HoverHandler {
                id: hoverHandler
                onHoveredChanged: () => {
                    if (hovered) {
                        collapseTimer.stop()
                        slider.shouldShow = true
                    } else {
                        collapseTimer.restart()
                    }
                }
            }
            id: slider

            property bool shouldShow: false
            Layout.fillWidth: true
            from: 0.0
            value: Pipewire.defaultAudioSink?.audio.volume ?? 0
            to: 1.0

            onMoved: () => {
                if (Pipewire.defaultAudioSink?.audio == null) return;
                Pipewire.defaultAudioSink.audio.volume = value
            }
            background: Rectangle {
                x: slider.leftPadding
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: slider.availableWidth
                height: implicitHeight
                color: Config.colors.fg0
                radius: 2

                Rectangle {
                    width: slider.visualPosition * parent.width
                    height: parent.height
                    color: Config.colors.accent
                }
            }

            handle: Rectangle {
                id: handle
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                implicitHeight: 20
                implicitWidth: 20
                radius: 10
                color: Config.colors.accent
                Pane {
                    x: -(implicitWidth/2 - handle.implicitWidth/2)
                    y: -(implicitHeight + 5)
                    horizontalPadding: 20
                    verticalPadding: 7.5
                    opacity: slider.shouldShow ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }

                    background: Rectangle {
                        anchors.fill: parent
                        color: Config.colors.fg0
                        radius: 999
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 13
                        color: Config.colors.bg0
                        text: Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100) + "%"
                    }
                }
            }
        }
        Image {
            width: 30
            source: "../icons/volume_up.svg"
        }
        PwObjectTracker { objects: [Pipewire.defaultAudioSink]}

    }

}
