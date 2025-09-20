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

        TextField {
            id: emailField
            placeholderText: "Email"
            width: parent.width
            background: Rectangle {
                color: Theme.inputBackground
                border.color: emailField.activeFocus ? Theme.inputFocusBorder : Theme.inputBorder
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

        TextField {
            id: passwordAgainField
            placeholderText: "Repeat Password"
            echoMode: TextInput.Password
            width: parent.width
            background: Rectangle {
                color: Theme.inputBackground
                border.color: passwordAgainField.activeFocus ? Theme.inputFocusBorder : Theme.inputBorder
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
