qt_add_library(PasswordManager STATIC
	passwordmanager.hpp
	passwordmanager.cpp
)

target_link_libraries(PasswordManager
    PRIVATE
        Qt6::Core
        Qt6::Quick
	Qt6::Sql
)

