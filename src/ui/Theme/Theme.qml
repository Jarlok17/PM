// Theme.qml
pragma Singleton
import QtQuick 2.15

QtObject {
    // Colors
    property color primaryColor: "#6a5acd"
    property color secondaryColor: "#483d8b"
    property color backgroundColor: "#1e1f2a"
    property color cardColor: "#2a2b3a"
    property color textColor: "#ffffff"
    property color buttonColor: "#4a4b5a"
    property color buttonHoverColor: "#5a5b6a"
    
    // Sizes
    property int paddingSmall: 8
    property int paddingMedium: 16
    property int paddingLarge: 24
    
    property int radiusSmall: 4
    property int radiusMedium: 8
    property int radiusLarge: 12
    
    // Font Sizes
    property int fontSizeSmall: 12
    property int fontSizeMedium: 16
    property int fontSizeLarge: 20
    property int fontSizeXLarge: 24
}
