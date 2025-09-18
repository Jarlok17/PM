qt_add_library(Clipboard STATIC
	textclipboard.hpp
)

target_link_libraries(Clipboard
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
)

