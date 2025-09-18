import QtQuick 2.15
import QtQuick.Controls 2.15
import "Theme"

ApplicationWindow {
    id: root
    visible: true
    width: 1000
    height: 700
    title: "PM"
    color: Theme.backgroundColor

    // Main StackView for navigation
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qrc:/Pages/LoginPage.qml"
    }
}
