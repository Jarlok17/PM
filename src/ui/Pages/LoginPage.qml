import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

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
                if (passwordField.item.text === "" || usernameField.item.text === "") {
                    showMessage("Error", "Password or Username can't be empty!")
                } else {
                    if(userManager.authenticateUser(usernameField.item.text, passwordField.item.text))
                    {
                        stackView.push("qrc:/Pages/MainPage.qml")
                        usernameField.item.clear()
                        passwordField.item.clear()
                    } else {
                        showMessage("Error", "Cant login in account!")
                    }
                }
            }
            Connections {
                target: userManager
                function onAuthenticationFailed(errorMessage) {
                    showMessage("Error", errorMessage)
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
