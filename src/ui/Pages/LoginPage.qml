import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Theme"

Page {
    background: Rectangle {
        color: Theme.backgroundColor
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker(Theme.backgroundColor, 1.2) }
            GradientStop { position: 1.0; color: Theme.backgroundColor }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Theme.spacingLarge
        width: Math.min(parent.width * 0.8, 400)

        Label {
            text: "Welcome to PM"
            font.pixelSize: Theme.fontSizeXXLarge
            font.bold: true
            color: Theme.primaryColor
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: Theme.paddingLarge
        }

        TextField {
            id: usernameField
            placeholderText: "Username"
            width: parent.width
            background: Rectangle {
                color: Theme.inputBackground
                border.color: usernameField.activeFocus ? Theme.inputFocusBorder : Theme.inputBorder
                border.width: 2
                radius: Theme.radiusMedium
            }
            color: Theme.textColor
            font.pixelSize: Theme.fontSizeMedium
            padding: Theme.paddingMedium
            selectByMouse: true
            selectedTextColor: Theme.textColor
            selectionColor: Theme.primaryLightColor
        }

        TextField {
            id: passwordField
            placeholderText: "Password"
            echoMode: TextInput.Password
            width: parent.width
            background: Rectangle {
                color: Theme.inputBackground
                border.color: passwordField.activeFocus ? Theme.inputFocusBorder : Theme.inputBorder
                border.width: 2
                radius: Theme.radiusMedium
            }
            color: Theme.textColor
            font.pixelSize: Theme.fontSizeMedium
            padding: Theme.paddingMedium
            selectByMouse: true
            selectedTextColor: Theme.textColor
            selectionColor: Theme.primaryLightColor
        }

        Button {
            text: "Login"
            width: parent.width
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
                if (passwordField.text === "" || usernameField.text === "") {
                    showMessage("Error", "Password or Username can't be empty!")
                } else { 
                    stackView.push("qrc:/Pages/MainPage.qml")
                }
            }
        }

        Button {
            text: "Create Account"
            width: parent.width
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
                stackView.push("qrc:/Pages/RegistrationPage.qml")
            }
        }
    }

    Loader {
        id: messageDialogLoader
        sourceComponent: Theme.messageDialog
        anchors.fill: parent
    }

    function showMessage(messageType, message) {
        messageDialogLoader.item.show(messageType, message, function() {
            console.log("Dialog closed");
        });
    }
}
