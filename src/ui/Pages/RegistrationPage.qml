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
        id: contentColumn
        anchors.centerIn: parent
        spacing: Theme.spacingLarge
        width: Math.min(parent.width * 0.8, 400)

        Label {
            text: "Create Account"
            font.pixelSize: Theme.fontSizeXXLarge
            font.bold: true
            color: Theme.primaryColor
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: Theme.paddingLarge
        }

        CustomTextField {
            id: emailField
            width: parent.width
            height: 60
            placeholderText: "email"
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

        CustomTextField {
            id: passwordAgainField 
            width: parent.width
            height: 60
            placeholderText: "repeat password"
            echoMode: TextInput.Password
        }

        CustomButton {
            text: "Register"
            width: parent.width
            height: 50
            onClicked: {
                if(emailField.text === "" ||
                usernameField.text === "" ||
                passwordField.text === "" ||
                passwordAgainField.text === "")
                {
                    showMessage("Error", "Email, username or passwords can't be empty!")
                }
                else if(passwordField.text !== passwordAgainField.text)
                {
                    showMessage("Error", "Passwords do not match!")
                } else { 
                    if(userManager.createUser(emailField.text, usernameField.text, passwordAgainField.text))
                    {
                        showMessage("Success", "Registration successful!", function() {
                            stackView.pop()
                            
                            emailField.clear()
                            usernameField.clear()
                            passwordField.clear()
                            passwordAgainField.clear()
                        })
                    } 
                }
            }
            Connections {
                target: userManager
                function onRegistrationFailed(errorMessage) {
                    showMessage("Error", errorMessage)
                }
            }
        }

        CustomButton {
            text: "Back"
            width: parent.width
            height: 50
            onClicked: {
                stackView.pop()
            }
        }
    }

    Loader {
        id: messageDialogLoader
        sourceComponent: Theme.messageDialog
        anchors.fill: parent
    }

    function showMessage(messageType, message, closeCallback) {
        messageDialogLoader.show(messageType, message, closeCallback);
    }
}
