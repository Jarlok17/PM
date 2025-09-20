qt_add_library(UserManager STATIC
	usermanager.hpp
	usermanager.cpp
)

target_link_libraries(UserManager
    PRIVATE
        Qt6::Core
        Qt6::Quick
	Qt6::Sql
)
