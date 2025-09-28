import QtQuick 2.15
import QtQuick.Templates as T

import "."

T.Button {
    id: control
    hoverEnabled: true
    background: Rectangle {
        color: control.pressed ? Theme.buttonPressedColor :
        control.hovered ? Theme.buttonHoverColor :
        Theme.buttonColor
        radius: Theme.radiusMedium
    }
    contentItem: Text {
        text: control.text
        color: Theme.textColor
        font.pixelSize: Theme.fontSizeMedium
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    padding: Theme.paddingMedium
}
