import QtQuick 2.15
import QtQuick.Controls 2.15

import "."

TextField {
    id: control
    
    implicitWidth: 200
    implicitHeight: 40

    color: Theme.textColor
    font.pixelSize: Theme.fontSizeMedium
    selectionColor: Theme.primaryLightColor
    selectedTextColor: Theme.textColor
    padding: Theme.paddingMedium
    placeholderTextColor: Theme.textSecondaryColor

    renderType: Text.NativeRendering
    verticalAlignment: TextInput.AlignVCenter

    background: Rectangle {
        anchors.fill: parent
        color: Theme.inputBackground
        border.color: control.activeFocus ? Theme.inputFocusBorder : Theme.inputBorder
        border.width: 2
        radius: Theme.radiusMedium
    }
}
