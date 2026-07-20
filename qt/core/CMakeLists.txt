# qt/core/CMakeLists.txt

project(ImaginatorQtCore LANGUAGES CXX)

message(STATUS "Configuring Imaginator Qt Core Library...")

set(IMAGINATOR_QT_CORE_LIB imaginator_qt_core_lib)

# --- Creation of the library ---
qt_add_library(${IMAGINATOR_QT_CORE_LIB} STATIC)

imaginator_enable_optimizations(${IMAGINATOR_QT_CORE_LIB})

# Explicitly ensure AUTOMOC runs on this target
set_target_properties(${IMAGINATOR_QT_CORE_LIB} PROPERTIES
    AUTOMOC TRUE
    AUTORCC TRUE
    AUTOUIC TRUE
)

set(CORE_SOURCES
)

set(QOBJECT_HEADERS
)

target_sources(${IMAGINATOR_QT_CORE_LIB}
    PRIVATE
        ${CORE_SOURCES} 
        ${QOBJECT_HEADERS}

    PUBLIC
        FILE_SET HEADERS
        BASE_DIRS include
)

# --- Configuration---
target_link_libraries(${IMAGINATOR_QT_CORE_LIB}
    PUBLIC
        Qt6::Core
        Qt6::Quick
        Qt6::Qml
        imaginator_core        
)

target_include_directories(${IMAGINATOR_QT_CORE_LIB}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> 
        $<INSTALL_INTERFACE:include> 
    PRIVATE
    # If necessary, include other internal paths to this library
    # ${CMAKE_CURRENT_SOURCE_DIR}/src # If the .cpp files need to be included from src/
    # Path to the core headers if needed in the .cpp files of this library
    # "${CMAKE_SOURCE_DIR}/core/include"
)

install(TARGETS ${IMAGINATOR_QT_CORE_LIB}
    EXPORT ImaginatorQtCoreTargets 
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} 
    FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/imaginator_qt_core
)

install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/imaginator_qt_core
    FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

message(STATUS "Imaginator Qt Core Library configured successfully.")
message(STATUS "   - Target: ${IMAGINATOR_QT_CORE_LIB}")
message(STATUS "")
