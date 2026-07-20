cmake_minimum_required(VERSION 4.2)

project(Imaginator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ============================================================
# Include CMake modules
# ============================================================
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(CompilerDetection)
include(BuildOptimization)
include(VcpkgHelpers)
include(PackageHelpers)

# ============================================================
# Verify C++23 support
# ============================================================
verify_cpp23_support() # From CompilerDetection.cmake

# ============================================================
# Build options
# ============================================================
option(BUILD_DESKTOP_UI "Build desktop UI" OFF)
option(BUILD_TESTS "Build tests" OFF)

# Aliases
option(desktop_ui "Alias for BUILD_DESKTOP_UI" OFF)
option(tests "Alias for BUILD_TESTS" OFF)

# Synchronize aliases
if(desktop_ui)
    set(BUILD_DESKTOP_UI ON)
endif()

if(tests)
    set(BUILD_TESTS ON)
endif()


# ============================================================
# Configuration Qt file generation
# ============================================================
if(BUILD_DESKTOP_UI OR BUILD_MOBILE_UI)
    # We will find Qt in the subdirectories (qt/core and qt/desktop) to ensure we get the correct components for each part of the project. However, we can set a global minimum version requirement here if needed.
    find_package(Qt6 REQUIRED COMPONENTS Core Quick Gui GuiPrivate ShaderTools Qml)
    message(STATUS "   - Qt Version: ${Qt6_VERSION}")
    message(STATUS "   - Qt Preferred Version: 6.10.x")
    qt_standard_project_setup(REQUIRES 6.10.0)
endif()

# ============================================================
# Configure vcpkg (if detected)
# ============================================================
configure_vcpkg_if_present() # From VcpkgHelpers.cmake

# ============================================================
# Find dependencies
# ============================================================
find_required_packages() # From PackageHelpers.cmake

# ============================================================
# Subprojects
# ============================================================

add_subdirectory(core)

if(BUILD_DESKTOP_UI)
    add_subdirectory(qt/core)
    add_subdirectory(qt/desktop)
endif()

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# ============================================================
# Apply compiler flags to ALL targets globally
# ============================================================
apply_compiler_flags_recursive(${CMAKE_CURRENT_SOURCE_DIR}) # From CompilerDetection.cmake

# ============================================================
# Configuration summary
# ============================================================
get_compiler_name(COMPILER_NAME) # From CompilerDetection.cmake

message(STATUS "")
message(STATUS "╔════════════════════════════════════════════════════════════╗")
message(STATUS "║  Imaginator ${PROJECT_VERSION} Configuration             ")
message(STATUS "╠════════════════════════════════════════════════════════════╣")
message(STATUS "║  Compiler        : ${COMPILER_NAME}")
message(STATUS "║  Build Type      : ${CMAKE_BUILD_TYPE}")
message(STATUS "║  C++ Standard    : C++${CMAKE_CXX_STANDARD}")
if(DEFINED VCPKG_TARGET_TRIPLET)
message(STATUS "║  vcpkg Triplet   : ${VCPKG_TARGET_TRIPLET}")
endif()
message(STATUS "╠════════════════════════════════════════════════════════════╣")
message(STATUS "║  Build Options:                                            ║")
message(STATUS "║    Desktop UI    : ${BUILD_DESKTOP_UI}")
message(STATUS "║    Tests         : ${BUILD_TESTS}")
message(STATUS "╚════════════════════════════════════════════════════════════╝")
message(STATUS "")
