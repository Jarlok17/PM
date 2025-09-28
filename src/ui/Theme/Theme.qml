// Theme.qml
pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    // Colors
    property color primaryColor: "#6a5acd"
    property color primaryLightColor: "#8378de"
    property color secondaryColor: "#483d8b"
    property color backgroundColor: "#1e1f2a"
    property color cardColor: "#2a2b3a"
    property color textColor: "#ffffff"
    property color textSecondaryColor: "#b0b0b0"
    property color buttonColor: "#4a4b5a"
    property color buttonHoverColor: "#5a5b6a"
    property color buttonPressedColor: "#3a3b4a"
    property color inputBackground: "#2d2e3d"
    property color inputBorder: "#3f4050"
    property color inputFocusBorder: primaryColor

    // Menu
    property color menuBackground: "#2a2b3a"
    property color menuBorder: "#3f4050"
    property color menuText: "#ffffff"
    property color menuHighlight: Theme.primaryColor
    property color menuHighlightText: "#ffffff"


    // Sizes
    property int paddingSmall: 8
    property int paddingMedium: 16
    property int paddingLarge: 24
    property int spacingSmall: 4
    property int spacingMedium: 8
    property int spacingLarge: 16
    
    property int radiusSmall: 4
    property int radiusMedium: 8
    property int radiusLarge: 12
    
    // Font Sizes
    property int fontSizeSmall: 12
    property int fontSizeMedium: 16
    property int fontSizeLarge: 20
    property int fontSizeXLarge: 24
    property int fontSizeXXLarge: 32
    
    property Component messageDialog: Component {
        Item {
            id: dialogRoot
            anchors.fill: parent
            visible: false
            z: 9999

            property string message: ""
            property string messageType: "Info"
            property var onClose: null

            Rectangle {
                anchors.fill: parent
                color: "#80000000"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {}
                }
            }

            Rectangle {
                id: dialogContainer
                width: Math.min(parent.width * 0.8, 400)
                anchors.centerIn: parent
                color: Theme.cardColor
                radius: Theme.radiusLarge
                border.color: {
                    switch(dialogRoot.messageType) {
                        case "Error": return "#ff4444";
                        case "Warning": return "#ffbb33";
                        case "Success": return "#00C851";
                        default: return Theme.primaryColor;
                    }
                }
                border.width: 2

                height: contentColumn.implicitHeight + Theme.paddingLarge * 2

                Column {
                    id: contentColumn
                    anchors {
                        fill: parent
                        margins: Theme.paddingLarge
                    }
                    spacing: Theme.spacingLarge

                    Text {
                        id: title
                        text: dialogRoot.messageType
                        color: {
                            switch(dialogRoot.messageType) {
                                case "Error": return "#ff4444";
                                case "Warning": return "#ffbb33";
                                case "Success": return "#00C851";
                                default: return Theme.primaryColor;
                            }
                        }
                        font.bold: true
                        font.pixelSize: Theme.fontSizeLarge
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: messageText
                        width: parent.width
                        text: dialogRoot.message
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        id: okButton
                        text: "OK"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.6
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
                            dialogRoot.visible = false;
                            if (dialogRoot.onClose) dialogRoot.onClose();
                        }
                    }
                }
            }

            function show(msgType, msg, closeCallback) {
                dialogRoot.messageType = msgType;
                dialogRoot.message = msg;
                dialogRoot.onClose = closeCallback;
                dialogRoot.visible = true;
            }
        }
    }
}
