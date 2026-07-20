# Debug: Show current directory
message(STATUS "Starting configuration of imaginator_core...")
message(STATUS "[core] CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")

# Source files (only .cpp files that get compiled)
set(CORE_SOURCES
)

# Verify sources exist
foreach(source ${CORE_SOURCES})
    set(full_path "${CMAKE_CURRENT_SOURCE_DIR}/${source}")
    if(NOT EXISTS "${full_path}")
        message(FATAL_ERROR "[core] Source file not found: ${full_path}")
    endif()
endforeach()

# Create library
add_library(imaginator_core STATIC ${CORE_SOURCES})

# PCH file and optimization
imaginator_enable_optimizations(imaginator_core include/pch.h)

# Add headers for IDE
file(GLOB_RECURSE HEADER_FILES "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
if(HEADER_FILES)
    set_source_files_properties(${HEADER_FILES} PROPERTIES HEADER_FILE_ONLY TRUE)
    target_sources(imaginator_core PRIVATE ${HEADER_FILES})
endif()

# Link dependencies (already verified by root CMakeLists via PackageHelpers)
# If we reach here, packages are guaranteed to exist
target_link_libraries(imaginator_core PUBLIC
    spdlog::spdlog
    stable-diffusion
)

# Include directories
target_include_directories(imaginator_core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# C++23 required
target_compile_features(imaginator_core PUBLIC cxx_std_23)

# Compiler flags (centralized in CompilerDetection.cmake)
apply_compiler_flags(imaginator_core)

# Properties
set_target_properties(imaginator_core PROPERTIES
    VERSION ${PROJECT_VERSION}
    POSITION_INDEPENDENT_CODE ON
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

# ============================================================
# Core configuration summary
# ============================================================
message(STATUS "")
message(STATUS "╔════════════════════════════════════════════════════════════╗")
message(STATUS "║  [core] imaginator_core configured                      ║")
message(STATUS "╠════════════════════════════════════════════════════════════╣")
message(STATUS "║  Type              : Static Library (STATIC)")
message(STATUS "║  Output Directory  : ${CMAKE_BINARY_DIR}/lib")
message(STATUS "╚════════════════════════════════════════════════════════════╝")
message(STATUS "")
