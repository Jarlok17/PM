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

        Loader {
            id: emailField
            width: parent.width
            sourceComponent: Theme.textField
            onLoaded: {
                item.placeholderText = "Email"
            }
        }

        Loader {
            id: usernameField
            width: parent.width
            sourceComponent: Theme.textField
            onLoaded: {
                item.placeholderText = "UserName"
            }
        }

        Loader {
            id: passwordField
            width: parent.width
            sourceComponent: Theme.textField
            onLoaded: {
                item.placeholderText = "Password"
                item.echoMode = TextInput.Password
            }
        }

        Loader {
            id: passwordAgainField
            width: parent.width
            sourceComponent: Theme.textField
            onLoaded: {
                item.placeholderText = "Repeat Password"
                item.echoMode = TextInput.Password
            }
        }

        Button {
            text: "Register"
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
                if(emailField.item.text === "" ||
                usernameField.item.text === "" ||
                passwordField.item.text === "" ||
                passwordAgainField.item.text === "")
                {
                    showMessage("Error", "Email, username or passwords can't be empty!")
                }
                else if(passwordField.item.text !== passwordAgainField.item.text)
                {
                    showMessage("Error", "Passwords do not match!")
                } else { 
                    if(userManager.createUser(emailField.item.text, usernameField.item.text, passwordAgainField.item.text))
                    {
                        showMessage("Success", "Registration successful!", function() {
                            stackView.pop()
                            
                            emailField.item.clear()
                            usernameField.item.clear()
                            passwordField.item.clear()
                            passwordAgainField.item.clear()
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

        Button {
            text: "Back"
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
        messageDialogLoader.item.show(messageType, message, closeCallback);
    }
}
