set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

add_subdirectory(clipboard)
add_subdirectory(dbmanager)
add_subdirectory(usermanager)
add_subdirectory(passwordmanager)

qt_add_resources(QML ui/qml.qrc ui/assets/assets.qrc)

qt_add_executable(PM
    main.cpp
    ${QML}
)

if(WIN32)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ui/assets/icons/app/icon.rc")
        target_sources(PM PRIVATE ui/assets/icons/app/icon.rc)
    endif()
endif()

target_link_libraries(PM
    PRIVATE
	DBManager
	UserManager
	PasswordManager
	Clipboard
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
	Qt6::Quick
)

qt_import_qml_plugins(PM)

qt_generate_deploy_app_script(
    TARGET PM
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)

install(SCRIPT ${deploy_script})

if(UNIX AND NOT APPLE)
	install(TARGETS PM RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
	install(FILES pm.desktop DESTINATION ${CMAKE_INSTALL_PREFIX}/share/applications)
	install(FILES ui/assets/icons/app/icon.png
		DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/64x64/apps
		RENAME pm.png)
endif()
