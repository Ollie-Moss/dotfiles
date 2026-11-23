import QtQuick
import QtQuick.Effects

Item {
    id: root
    property url path
    property color color: "transparent"   // leave unset for the original image colors
    property real size: 24

    // Colorize only when a visible color was provided
    readonly property bool isColored: color.a > 0

    implicitWidth: size
    implicitHeight: size

    Image {
        id: img
        anchors.fill: parent
        source: root.path
        sourceSize: Qt.size(root.width, root.height) // Ensures crisp SVG rendering
        visible: !root.isColored // When colored, the MultiEffect draws it instead
    }

    // Only created when a color is set, so uncolored icons have no effect overhead
    Loader {
        anchors.fill: parent
        active: root.isColored

        sourceComponent: MultiEffect {
            source: img
            colorization: 1.0
            colorizationColor: root.color
        }
    }
}
