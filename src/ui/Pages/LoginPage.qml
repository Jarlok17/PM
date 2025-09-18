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
            text: "Login"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                stackView.push("qrc:/Pages/MainPage.qml")
            }
        }

        Button {
            text: "Create Account"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                stackView.push("qrc:/Pages/RegistrationPage.qml")
            }
        }
    }
}
