import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Theme"

Page {
    background: Rectangle {
        color: Theme.backgroundColor
    }

    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.6
        color: Theme.cardColor
        radius: Theme.radiusLarge
        
        Label {
            anchors.centerIn: parent
            text: "Welcome to Main Page " + userManager.getCurrentUser().username + "!"
            font.pixelSize: Theme.fontSizeXLarge
            font.bold: true
            color: Theme.textColor
        }
    }

    Button {
        text: "Logout"
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: Theme.paddingLarge
        }
        width: 200
        hoverEnabled: true
        background: Rectangle {
            color: parent.pressed ? Theme.buttonPressedColor :
            parent.hovered ? Theme.buttonHoverColor :
            Theme.buttonColor
            radius: Theme.radiusMedium
        }
        contentItem: Text {
            text: parent.text
            color: Theme.textColor
            font.pixelSize: Theme.fontSizeMedium
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        padding: Theme.paddingMedium
        onClicked: {
            showMessage("Info", "Are you sure you want to logout?", function() {
                stackView.pop()
            })
        }
    }

    Loader {
        id: messageDialogLoader
        sourceComponent: Theme.messageDialog
        anchors.fill: parent
    }

    function showMessage(messageType, message, closeCallback) {
        messageDialogLoader.item.show(messageType, message, closeCallback);
    }
}
