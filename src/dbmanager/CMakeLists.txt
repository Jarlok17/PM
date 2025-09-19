qt_add_library(DBManager STATIC
	dbmanager.hpp
	dbmanager.cpp
)

target_link_libraries(DBManager
    PRIVATE
        Qt6::Core
        Qt6::Quick
	Qt6::Sql
)

