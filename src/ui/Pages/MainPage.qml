import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    background: Rectangle {
        color: "transparent"
    }

    Label {
        anchors.centerIn: parent
        text: "Welcome to Main Page!"
        font.pixelSize: 24
    }

    Button {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
        text: "Logout"
        onClicked: {
            stackView.pop()
        }
    }
}
