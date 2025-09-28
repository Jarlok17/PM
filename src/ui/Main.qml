import QtQuick 2.15
import QtQuick.Controls 2.15
import "Theme"

ApplicationWindow {
    id: root
    visible: true
    width: 1000
    height: 700
    minimumHeight: 1000
    maximumWidth: 700
    title: "PM"
    color: Theme.backgroundColor

    palette {
        window: Theme.backgroundColor
        windowText: Theme.textColor
        base: "#363636"
        text: Theme.textColor
        button: Theme.primaryColor
        buttonText: Theme.textColor
        highlight: Theme.primaryColor
        highlightedText: Theme.textColor
        placeholderText: Theme.textSecondaryColor 
    }

    // Main StackView for navigation
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qrc:/Pages/LoginPage.qml"
    }
}
