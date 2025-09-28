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

        CustomTextField {
            id: usernameField
            width: parent.width
            height: 60
            placeholderText: "username"
        }

        CustomTextField {
            id: passwordField
            width: parent.width
            height: 60 
            placeholderText: "password"
            echoMode: TextInput.Password
        } 

        
        CustomButton {
            text: "Login"
            width: parent.width
            height: 50
            onClicked: {
                if (passwordField.text === "" || usernameField.text === "") {
                    showMessage("Error", "Password or Username can't be empty!")
                } else {
                    if (userManager.authenticateUser(usernameField.text, passwordField.text)) {
                        stackView.push("qrc:/Pages/MainPage.qml")
                        usernameField.clear()
                        passwordField.clear()
                    } else {
                        showMessage("Error", "Cant login in account!")
                    }
                }
            }
        }

        
        CustomButton {
            text: "Create Account"
            width: parent.width
            height: 50
            onClicked: stackView.push("qrc:/Pages/RegistrationPage.qml")
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
