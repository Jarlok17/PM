import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Theme"

Page {
    background: Rectangle {
        color: Theme.backgroundColor
    }

    StackView {
        id: mainStackView
        anchors.fill: parent
        initialItem: welcomeComponent

        Component {
            id: welcomeComponent
            Column {
                anchors.centerIn: parent
                spacing: Theme.spacingLarge

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Welcome to PM"
                    font.pixelSize: Theme.fontSizeXXLarge
                    font.bold: true
                    color: Theme.primaryColor
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Your password manager"
                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.textSecondaryColor
                }
            }
        }
    }

    Component.onCompleted: {
        // If user login in, show passwords page
        if (userManager.currentUserId !== -1) {
            mainStackView.push("qrc:/Pages/PasswordsPage.qml")
        }
    }

    Connections {
        target: userManager
        function onCurrentUserIdChanged(userId) {
            if (userId !== -1) {
                mainStackView.push("qrc:/Pages/PasswordsPage.qml")
            } else {
                mainStackView.pop(null)
            }
        }
    }
}
