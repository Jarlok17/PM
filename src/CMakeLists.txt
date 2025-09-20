set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

add_subdirectory(clipboard)
add_subdirectory(dbmanager)
add_subdirectory(usermanager)

qt_add_resources(QML ui/qml.qrc)

qt_add_executable(PM
    main.cpp
    ${QML}
)

target_link_libraries(PM
    PRIVATE
	DBManager
	UserManager
	Clipboard
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
)

qt_import_qml_plugins(PM)
