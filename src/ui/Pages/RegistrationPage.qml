import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    background: Rectangle {
        color: "transparent"
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        TextField {
            id: emailField
            placeholderText: "Email"
            width: 200
        }

        TextField {
            id: usernameField
            placeholderText: "Username"
            width: 200
        }

        TextField {
            id: passwordField
            placeholderText: "Password"
            echoMode: TextInput.Password
            width: 200
        }

        Button {
            text: "Register"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                stackView.pop()
            }
        }

        Button {
            text: "Back"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                stackView.pop()
            }
        }
    }
}
