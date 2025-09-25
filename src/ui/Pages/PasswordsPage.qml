import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../Theme"
import PM 1.0

Page {
    id: passwordsPage
    background: Rectangle {
        color: Theme.backgroundColor
    }

    property string currentView: "all"
    property int selectedPasswordId: -1
    property string selectedCategory: ""
    property string selectedPasswordTitle: ""
    property string currentSearchTerm: ""

    ListModel {
        id: categoriesModel
    }

    function updateCategories() {
        categoriesModel.clear()
        var categories = passwordManager.getCategories()
        for (var i = 0; i < categories.length; i++) {
            categoriesModel.append({name: categories[i]})
        }
        console.log("Categories updated:", categories.length)
    }

    function applyFilter() {
        if (currentView === "all") {
            passwordManager.clearFilter()
        } else if (currentView === "favorites") {
            passwordManager.setFilter("favorites", "")
        } else if (currentView === "category") {
            passwordManager.setFilter("category", selectedCategory)
        }

        if (currentSearchTerm !== "") {
            passwordManager.searchPasswords(currentSearchTerm)
        }
    }

    
    function performSearch(searchText) {
        currentSearchTerm = searchText
        passwordManager.searchPasswords(searchText)
    }

    function clearSearch() {
        currentSearchTerm = ""
        searchField.text = ""
        applyFilter()
    }

    onCurrentViewChanged: {
        clearSearch()
        applyFilter()
    }
    onSelectedCategoryChanged: {
        clearSearch()
        applyFilter()
    }

    Component.onCompleted: {
        updateCategories()
    }

    // Side menu
    Rectangle {
        id: sideMenu
        width: 250
        height: parent.height
        color: Theme.cardColor
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Menu header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: Theme.primaryColor
                Layout.margins: 10
                radius: Theme.radiusMedium

                Label {
                    anchors.centerIn: parent
                    text: "Password Manager"
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                }
            }

            // Navigation buttons
            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: Theme.spacingLarge
                spacing: Theme.spacingSmall

                // "All passwords" button
                Button {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.paddingMedium
                    Layout.rightMargin: Theme.paddingMedium
                    text: "All Passwords"
                    hoverEnabled: true
                    background: Rectangle {
                        color: parent.pressed ? Theme.buttonPressedColor :
                        parent.hovered ? Theme.buttonHoverColor :
                        passwordsPage.currentView === "all" ? Theme.primaryLightColor : "transparent"
                        radius: Theme.radiusSmall
                    }
                    contentItem: Text {
                        text: parent.text
                        color: passwordsPage.currentView === "all" ? Theme.textColor : Theme.textSecondaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: Theme.paddingMedium
                    }
                    onClicked: {
                        passwordsPage.currentView = "all"
                        passwordsPage.selectedCategory = ""
                    }
                }

                // "Favorites" button
                Button {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.paddingMedium
                    Layout.rightMargin: Theme.paddingMedium
                    text: "Favorites"
                    hoverEnabled: true
                    background: Rectangle {
                        color: parent.pressed ? Theme.buttonPressedColor :
                        parent.hovered ? Theme.buttonHoverColor :
                        passwordsPage.currentView === "favorites" ? Theme.primaryLightColor : "transparent"
                        radius: Theme.radiusSmall
                    }
                    contentItem: Text {
                        text: parent.text
                        color: passwordsPage.currentView === "favorites" ? Theme.textColor : Theme.textSecondaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: Theme.paddingMedium
                    }
                    onClicked: {
                        passwordsPage.currentView = "favorites"
                        passwordsPage.selectedCategory = ""
                    }
                }

                // Divider
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    Layout.leftMargin: Theme.paddingMedium
                    Layout.rightMargin: Theme.paddingMedium
                    color: Theme.inputBorder
                    Layout.topMargin: Theme.spacingMedium
                    Layout.bottomMargin: Theme.spacingMedium
                }

                // Categories header
                Label {
                    Layout.leftMargin: Theme.paddingMedium
                    text: "CATEGORIES"
                    color: Theme.textSecondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                }

                // Categories list - використовуємо ListModel
                Repeater {
                    model: categoriesModel
                    delegate: Button {
                        Layout.fillWidth: true
                        Layout.leftMargin: Theme.paddingMedium
                        Layout.rightMargin: Theme.paddingMedium
                        text: name
                        hoverEnabled: true
                        background: Rectangle {
                            color: parent.pressed ? Theme.buttonPressedColor :
                            parent.hovered ? Theme.buttonHoverColor :
                            (passwordsPage.currentView === "category" && passwordsPage.selectedCategory === name) ? 
                            Theme.primaryLightColor : "transparent"
                            radius: Theme.radiusSmall
                        }
                        contentItem: Text {
                            text: parent.text
                            color: (passwordsPage.currentView === "category" && passwordsPage.selectedCategory === name) ? 
                            Theme.textColor : Theme.textSecondaryColor
                            font.pixelSize: Theme.fontSizeMedium
                            horizontalAlignment: Text.AlignLeft
                            leftPadding: Theme.paddingMedium
                        }
                        onClicked: {
                            passwordsPage.currentView = "category"
                            passwordsPage.selectedCategory = name
                        }
                    }                
                }
            }

            // Spacer
            Item {
                Layout.fillHeight: true
            }

            // "Logout" button
            Button {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.paddingMedium
                Layout.rightMargin: Theme.paddingMedium
                Layout.bottomMargin: Theme.paddingMedium
                text: "Logout"
                hoverEnabled: true
                background: Rectangle {
                    color: parent.pressed ? Theme.buttonPressedColor :
                    parent.hovered ? Theme.buttonHoverColor :
                    Theme.buttonColor
                    radius: Theme.radiusSmall
                }
                contentItem: Text {
                    text: parent.text
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    horizontalAlignment: Text.AlignHCenter
                }
                onClicked: {
                    userManager.setCurrentUserId(-1)
                    stackView.pop()
                }
            }
        }
    }

    // Main content
    Rectangle {
        id: contentArea
        anchors {
            left: sideMenu.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        color: Theme.backgroundColor

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingMedium

            // Search and add panel
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                color: Theme.cardColor

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingMedium
                    spacing: Theme.spacingMedium

                    // Search field
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search by title or notes..."
                        background: Rectangle {
                            color: Theme.inputBackground
                            border.color: searchField.activeFocus ? Theme.inputFocusBorder : Theme.inputBorder
                            border.width: 4
                            radius: Theme.radiusMedium
                        }
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        padding: Theme.paddingMedium

                        rightPadding: clearSearchButton.width + Theme.paddingMedium

                        onTextChanged: {
                            if (text.length > 0) {
                                performSearch(text)
                            } else {
                                clearSearch()
                            }
                        }

                        Keys.onEscapePressed: {
                            clearSearch()
                            focus = false
                        }
                    }
                    
                    // Add password button
                    Button {
                        id: addPasswordButton
                        text: "Add Password"
                        hoverEnabled: true
                        background: Rectangle {
                            color: addPasswordButton.pressed ? Theme.buttonPressedColor :
                            addPasswordButton.hovered ? Theme.buttonHoverColor :
                            Theme.primaryColor
                            radius: Theme.radiusMedium
                        }
                        contentItem: Text {
                            text: addPasswordButton.text
                            color: Theme.textColor
                            font.pixelSize: Theme.fontSizeMedium
                            font.bold: true
                        }
                        padding: Theme.paddingMedium
                        onClicked: {
                            addPasswordDialog.open()
                        }
                    }
                }
            }

            // Current category header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: Theme.backgroundColor

                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }
                    text: {
                        if (passwordsPage.currentView === "all") return "All Passwords (" + listView.count + ")"
                        if (passwordsPage.currentView === "favorites") return "Favorite Passwords (" + listView.count + ")"
                        if (passwordsPage.currentView === "category") return passwordsPage.selectedCategory + " Passwords (" + listView.count + ")"
                        return "Passwords (" + listView.count + ")"
                    }
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                }
            }

            // Passwords list
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: passwordManager
                delegate: passwordDelegate
                spacing: Theme.spacingSmall

                // Show message if no passwords
                Label {
                    anchors.centerIn: parent
                    text: {
                        if (passwordsPage.currentView === "all") return "No passwords yet"
                        if (passwordsPage.currentView === "favorites") return "No favorite passwords"
                        if (passwordsPage.currentView === "category") return "No passwords in " + passwordsPage.selectedCategory + " category"
                        return "No passwords yet"
                    }
                    color: Theme.textSecondaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    visible: listView.count === 0
                }
            }
        }
    }

    // Password delegate component (залишаємо без змін)
    Component {
        id: passwordDelegate
        Rectangle {
            width: listView.width - Theme.paddingMedium * 2
            height: 80
            radius: Theme.radiusMedium
            color: Theme.cardColor
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium
                spacing: Theme.spacingMedium

                // Menu button
                Button {
                    id: menuButton
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    hoverEnabled: true
                    background: Rectangle {
                        color: menuButton.pressed ? Theme.buttonPressedColor :
                        menuButton.hovered ? Theme.buttonHoverColor : "transparent"
                        radius: Theme.radiusSmall
                    }
                    contentItem: Image {
                        source: "qrc:/icons/menu.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    onClicked: {
                        passwordsPage.selectedPasswordId = model.id
                        passwordsPage.selectedPasswordTitle = model.title
                        contextMenu.x = menuButton.x
                        contextMenu.y = menuButton.y + menuButton.height
                        contextMenu.open()
                    }
                }

                Column {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: Theme.spacingSmall
                    clip: true

                    Text {
                        text: model.title
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: true
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Text {
                        text: model.notes
                        color: Theme.textSecondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        elide: Text.ElideRight
                        width: parent.width
                    }
                }

                Button {
                    id: favoriteButton
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    hoverEnabled: true
                    ToolTip.visible: hovered
                    ToolTip.text: "Favorite password"
                    background: Rectangle {
                        color: favoriteButton.pressed ? Theme.buttonPressedColor :
                        favoriteButton.hovered ? Theme.buttonHoverColor :
                        "transparent"
                        radius: Theme.radiusSmall
                    }
                    contentItem: Image {
                        source: model.favorite ? "qrc:/icons/star-filled.png" : "qrc:/icons/star.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    onClicked: {
                        passwordManager.toggleFavorite(model.id)
                    }
                }

                Button {
                    id: copyButton
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    hoverEnabled: true
                    ToolTip.visible: hovered
                    ToolTip.text: "Copy password"
                    background: Rectangle {
                        color: copyButton.pressed ? Theme.buttonPressedColor :
                        copyButton.hovered ? Theme.buttonHoverColor :
                        "transparent"
                        radius: Theme.radiusSmall
                    }
                    contentItem: Image {
                        source: "qrc:/icons/copy.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    onClicked: {
                        textClipboard.copy(passwordManager.decryptPassword(model.password, userManager.currentUserId.toString()))
                        showMessage("Success", "Password copied to clipboard!")
                    }
                }
            }

            Menu {
                id: contextMenu
                modal: true
                dim: false

                MenuItem {
                    text: "Edit"
                    onTriggered: {
                        editPasswordDialog.passwordId = passwordsPage.selectedPasswordId
                        var passwordData = passwordManager.getPassword(passwordsPage.selectedPasswordId)
                        editPasswordDialog.titleText = passwordData.title
                        editPasswordDialog.passwordText = passwordManager.decryptPassword(passwordData.password, userManager.currentUserId.toString())
                        editPasswordDialog.notesText = passwordData.notes
                        editPasswordDialog.categoryText = passwordData.category
                        editPasswordDialog.favorite = passwordData.favorite
                        editPasswordDialog.open()
                    }
                }

                MenuItem {
                    text: "Delete"
                    onTriggered: {
                        deleteConfirmDialog.passwordId = passwordsPage.selectedPasswordId
                        deleteConfirmDialog.passwordTitle = passwordsPage.selectedPasswordTitle
                        deleteConfirmDialog.open()
                    }
                }

                MenuSeparator {}

                MenuItem {
                    text: "Show Details"
                    onTriggered: {
                        passwordDetailsDialog.passwordId = passwordsPage.selectedPasswordId
                        passwordDetailsDialog.open()
                    }
                }
            }
        }
    }

    // For clipboard operations
    TextClipboard {
        id: textClipboard
    }

    // Message dialog loader
    Loader {
        id: messageDialogLoader
        sourceComponent: Theme.messageDialog
        anchors.fill: parent
    }

    function showMessage(messageType, message, closeCallback) {
        messageDialogLoader.item.show(messageType, message, closeCallback);
    }

    // Connections for PasswordManager signals
    Connections {
        target: passwordManager

        function onCategoriesChanged() {
            console.log("Categories changed, updating...")
            updateCategories()

            // Якщо поточна категорія більше не існує, повертаємося до "all"
            var currentCategories = passwordManager.getCategories()
            if (passwordsPage.currentView === "category" && !currentCategories.includes(passwordsPage.selectedCategory)) {
                passwordsPage.currentView = "all"
                passwordsPage.selectedCategory = ""
                passwordManager.clearFilter()
            }
        }

        function onPasswordAdded(success) {
            if (success) {
                showMessage("Success", "Password added successfully!")
                // Очищаємо поля діалогу після успішного додавання
                addPasswordDialog.titleText = ""
                addPasswordDialog.passwordText = ""
                addPasswordDialog.notesText = ""
                addPasswordDialog.categoryText = ""
                addPasswordDialog.favorite = false
            } else {
                showMessage("Error", "Failed to add password!")
            }
        }

        function onPasswordUpdated(success) {
            if (success) {
                showMessage("Success", "Password updated successfully!")
            }
        }

        function onPasswordDeleted(success) {
            if (success) {
                showMessage("Success", "Password deleted successfully!")
            }
        }

        function onErrorOccurred(errorMessage) {
            showMessage("Error", errorMessage)
        }
    }

    Dialog {
        id: addPasswordDialog
        title: "Add New Password"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        closePolicy: Popup.CloseOnEscape
        anchors.centerIn: parent
        width: 400
        height: 400

        property alias titleText: titleField.text
        property alias passwordText: passwordField.text
        property alias notesText: notesField.text
        property alias categoryText: categoryField.text
        property alias favorite: favoriteSwitch.checked

        // Запобігаємо подвійному виклику
        onAccepted: {
            if (titleText.trim() === "" || passwordText.trim() === "") {
                showMessage("Error", "Title and password cannot be empty!")
                return
            }
            passwordManager.addPassword(titleText, passwordText, notesText, categoryText, favorite)
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingMedium

            TextField {
                id: titleField
                Layout.fillWidth: true
                placeholderText: "Title *"
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                placeholderText: "Password *"
                echoMode: TextInput.Password
            }

            TextField {
                id: notesField
                Layout.fillWidth: true
                placeholderText: "Notes"
            }

            TextField {
                id: categoryField
                Layout.fillWidth: true
                placeholderText: "Category"
            }

            RowLayout {
                Switch {
                    id: favoriteSwitch
                    text: "Favorite"
                }
            }
        }
    }
    Dialog {
        id: editPasswordDialog
        title: "Edit Password"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        width: 400
        height: 400

        property int passwordId: -1
        property alias titleText: editTitleField.text
        property alias passwordText: editPasswordField.text
        property alias notesText: editNotesField.text
        property alias categoryText: editCategoryField.text
        property alias favorite: editFavoriteSwitch.checked

        onAccepted: {
            if (titleText.trim() === "" || passwordText.trim() === "") {
                showMessage("Error", "Title and password cannot be empty!")
                return
            }
            passwordManager.updatePassword(passwordId, titleText, passwordText, notesText, categoryText, favorite)
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingMedium

            TextField {
                id: editTitleField
                Layout.fillWidth: true
                placeholderText: "Title *"
            }

            TextField {
                id: editPasswordField
                Layout.fillWidth: true
                placeholderText: "Password *"
                echoMode: TextInput.Password
            }

            TextField {
                id: editNotesField
                Layout.fillWidth: true
                placeholderText: "Notes"
            }

            TextField {
                id: editCategoryField
                Layout.fillWidth: true
                placeholderText: "Category"
            }

            RowLayout {
                Switch {
                    id: editFavoriteSwitch
                    text: "Favorite"
                }
            }
        }
    }

    Dialog {
        id: deleteConfirmDialog
        title: "Confirm Delete"
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        anchors.centerIn: parent
        width: 300
        height: 150

        property int passwordId: -1
        property string passwordTitle: ""

        Label {
            anchors.centerIn: parent
            text: "Delete '" + deleteConfirmDialog.passwordTitle + "'?"
            font.pixelSize: Theme.fontSizeMedium
        }

        onAccepted: {
            passwordManager.deletePassword(deleteConfirmDialog.passwordId)
        }
    }

    Dialog {
        id: passwordDetailsDialog
        title: "Password Details"
        modal: true
        standardButtons: Dialog.Close
        anchors.centerIn: parent
        width: 400
        height: 350

        property int passwordId: -1
        property bool passwordVisible: false

        onAboutToShow: {
            // Скидаємо стан при відкритті
            passwordVisible = false
            passwordLabel.text = "Password: ••••••••"
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingMedium

            Label {
                text: "Title: " + (passwordDetailsDialog.passwordId !== -1 ? getPasswordField("title") : "")
                font.bold: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                id: passwordLabel
                text: "Password: ••••••••"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                text: "Notes: " + (passwordDetailsDialog.passwordId !== -1 ? getPasswordField("notes") : "No notes")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                text: "Category: " + (passwordDetailsDialog.passwordId !== -1 ? getPasswordField("category") : "No category")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                text: "Favorite: " + (passwordDetailsDialog.passwordId !== -1 ? (getPasswordField("favorite") ? "Yes" : "No") : "No")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingMedium

                Button {
                    text: passwordDetailsDialog.passwordVisible ? "Hide Password" : "Show Password"
                    onClicked: {
                        if (!passwordDetailsDialog.passwordVisible) {
                            var passwordData = passwordManager.getPassword(passwordDetailsDialog.passwordId)
                            if (passwordData && passwordData.password) {
                                passwordLabel.text = "Password: " + passwordData.password
                                passwordDetailsDialog.passwordVisible = true
                            } else {
                                showMessage("Error", "Failed to retrieve password")
                            }
                        } else {
                            passwordLabel.text = "Password: ••••••••"
                            passwordDetailsDialog.passwordVisible = false
                        }
                    }
                }
            }
        }

        function getPasswordField(fieldName) {
            var passwordData = passwordManager.getPassword(passwordDetailsDialog.passwordId)
            return passwordData && passwordData[fieldName] !== undefined ? passwordData[fieldName] : ""
        }
    }
}
