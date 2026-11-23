import QtQuick
import "../config.js" as Config

Text {
    id: root

    property double fontSize: 12
    property double fontWeight: 8
    property bool propo: false

    color: Config.colors.fg0
    elide: Text.ElideRight

    font {
        pointSize: fontSize
        weight: root.fontWeight * 100
    }
}
