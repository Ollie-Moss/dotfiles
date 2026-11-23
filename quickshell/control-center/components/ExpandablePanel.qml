import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import "../config.js" as Config

Item {
    id: root

    property Component defaultItem

    property color boxColor: Config.colors.bg0

    // public
    property double padding: 0

    property var boxHeight
    property var boxHeightOpened

    property var boxWidth
    property var boxWidthOpened

    property double boxRadius: 12
    property double boxRadiusOpened: 14

    function openWith(comp) {
        hideTimer.stop()
        if (root.open == true) {
            root.openedItem = comp
            return;
        }
        root.openedItem = comp
        root.open = true
    }

    // Private
    property Component openedItem
    property alias rect: container
    property alias stack: containerContent

    property bool open: false

    readonly property real targetWidth: calculateWidth()
    readonly property real targetHeight: calculateHeight()
    implicitHeight: calculateHeight()
    implicitWidth: calculateWidth()

    function calculateHeight(): double {
        if (state === "opened")
        return boxHeightOpened ?? (containerContent.currentItem.implicitHeight + 2 * root.padding)

        return boxHeight ?? (containerContent.currentItem.implicitHeight + 2 * root.padding)
    }

    function calculateWidth(): double {
        if (state === "opened")
        return boxWidthOpened ?? (containerContent.currentItem.implicitWidth + 2 * root.padding)

        return boxWidth ?? (containerContent.currentItem.implicitWidth + 2 * root.padding)
    }

    Behavior on implicitWidth  { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
    Behavior on implicitHeight { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
    Behavior on boxRadius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

    opacity: !Hyprland.focusedWorkspace?.hasFullscreen ? 1 : 0
    visible: opacity > 0
    enabled: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

    anchors {
        top: parent.top
    }

    states: [
    State {
        name: "closed"
        when: root.open == false

        PropertyChanges {
            root.implicitHeight: calculateHeight()
            root.implicitWidth: calculateWidth()

            container.bottomRightRadius: boxRadius
            container.bottomLeftRadius:  boxRadius
        }

        StateChangeScript {
            script: {
                stack.replace(root.defaultItem);
            }
        }
    },
    State {
        name: "opened"
        when: root.open == true
        PropertyChanges {
            root.implicitHeight: calculateHeight()
            root.implicitWidth: calculateWidth()

            container.bottomRightRadius: boxRadiusOpened
            container.bottomLeftRadius:  boxRadiusOpened
        }

        StateChangeScript {
            script: {
                stack.replace(root.openedItem);
            }
        }
    }
    ]

    Timer {
        id: hideTimer

        interval: 100
        repeat: false
        running: false

        onTriggered: {
            root.open = false
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if(!hovered) {
                hideTimer.restart();
            }
        }
    }

    Rectangle {
        id: container

        clip: true
        color: root.boxColor
        bottomRightRadius: boxRadius
        bottomLeftRadius:  boxRadius

        anchors.fill: parent

        StackView {
            id: containerContent

            anchors.top: parent.top
            anchors.topMargin: root.padding
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.max(0, root.targetWidth - 2 * root.padding)
            height: Math.max(0, root.targetHeight - 2 * root.padding)

            pushEnter: Transition {}
            pushExit: Transition {}
            popEnter: Transition {}
            popExit: Transition {}
            replaceEnter: Transition {
                PropertyAnimation {
                    duration: 50
                    from: 0
                    property: "opacity"
                    to: 1
                }
            }
            replaceExit: Transition {
                PropertyAnimation {
                    duration: 50
                    from: 1
                    property: "opacity"
                    to: 0
                }
            }

            Component.onCompleted: containerContent.push(root.defaultItem)
            onCurrentItemChanged: {
                if (currentItem) {
                    // Dynamically center the incoming child to the StackView
                    currentItem.anchors.horizontalCenter = containerContent.horizontalCenter;
                    currentItem.anchors.verticalCenter = containerContent.verticalCenter;
                }
            }
        }
    }
}
