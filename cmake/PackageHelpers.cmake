# PackageHelpers.cmake - Helper functions to find and verify required packages

# ============================================================
# Download CPM.cmake automatically if not present
# ============================================================
if(NOT EXISTS "${CMAKE_BINARY_DIR}/cmake/CPM.cmake")
    message(STATUS "Downloading CPM.cmake...")
    file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/cmake")
    file(DOWNLOAD
        https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake
        "${CMAKE_BINARY_DIR}/cmake/CPM.cmake"
        TLS_VERIFY ON
    )
endif()

include("${CMAKE_BINARY_DIR}/cmake/CPM.cmake")
message(STATUS "Using CPM.cmake from: ${CMAKE_BINARY_DIR}/cmake/CPM.cmake")

# ============================================================
# Find all required packages
# ============================================================
function(find_required_packages)
    # spdlog (mandatory)
    find_spdlog_package()

    # stable-diffusion.cpp (mandatory)
    find_stable_diffusion_package()

    summarize_found_packages()
    warn_halide_requirements()
endfunction()


# ============================================================
# Find spdlog
# ============================================================
function(find_spdlog_package)
    message(STATUS "Fetching spdlog v1.17.0 via CPM")

    CPMAddPackage(
        NAME spdlog
        GITHUB_REPOSITORY gabime/spdlog
        GIT_TAG         v1.17.0
    )

    if(TARGET spdlog::spdlog)
        set(spdlog_FOUND TRUE PARENT_SCOPE)
        set(spdlog_VERSION "1.17.0" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Failed to download spdlog via CPM.")
    endif()

endfunction()


#============================================================
# Find stable-diffusion.cpp
#============================================================
function(find_stable_diffusion_package)
    message(STATUS "Fetching stable-diffusion.cpp")

    # We use FetchContent instead of CPM because stable-diffusion.cpp has submodules that need to be initialized.
    include(FetchContent)

    FetchContent_Declare(
        sd_cpp
        GIT_REPOSITORY https://github.com/leejet/stable-diffusion.cpp.git
        GIT_TAG        master.
    )

    # Disable building examples in stable-diffusion.cpp to avoid unnecessary dependencies and reduce build time.
    set(SD_BUILD_EXAMPLES OFF CACHE INTERNAL "")

    # stable-diffusion.cpp will search Vulkan, CUDA, etc.
    
    FetchContent_MakeAvailable(sd_cpp)

    # the target name is "sd" as defined in stable-diffusion.cpp's
    if(TARGET sd)
        set(stable_diffusion_FOUND TRUE PARENT_SCOPE)
        set(stable_diffusion_VERSION "master" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Failed to configure stable-diffusion.cpp. Check Vulkan/CUDA SDKs.")
    endif()

endfunction()

# ============================================================
# Summary of all found packages
# ============================================================
function(summarize_found_packages)
    
    message(STATUS "╔════════════════════════════════════════════════════════════╗")
    message(STATUS "║    Summary Package Information                             ║")
    message(STATUS "╠════════════════════════════════════════════════════════════╣")
    if(spdlog_FOUND)
        message(STATUS "║ spdlog : ${spdlog_VERSION}")
    else()
        message(STATUS "║ spdlog : Not Found")
    endif()
    
    if(stable_diffusion_FOUND)
        message(STATUS "║ stable-diffusion.cpp : ${stable_diffusion_VERSION}")
    else()
        message(STATUS "║ stable-diffusion.cpp : Not Found")
    endif()


    message(STATUS "╚════════════════════════════════════════════════════════════╝")
    message(STATUS "")

    message(STATUS "╔════════════════════════════════════════════════════════════╗")
    message(STATUS "║    Preferred Version                                       ║")
    message(STATUS "╠════════════════════════════════════════════════════════════╣")
    message(STATUS "║ spdlog : 1.17.0")
    message(STATUS "║ stable-diffusion.cpp : latest")
    message(STATUS "╚════════════════════════════════════════════════════════════╝")
    message(STATUS "")
endfunction()
