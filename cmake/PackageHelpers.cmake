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

    include(FetchContent)

    FetchContent_Declare(
        sd_cpp
        GIT_REPOSITORY https://github.com/leejet/stable-diffusion.cpp.git
        GIT_TAG        master
        GIT_SHALLOW    TRUE
        GIT_SUBMODULES_RECURSE TRUE
    )

    set(SD_WEBP              ON  CACHE BOOL "" FORCE)
    set(SD_WEBM              ON  CACHE BOOL "" FORCE)
    set(SD_USE_SYSTEM_WEBP   OFF CACHE BOOL "" FORCE)
    set(SD_USE_SYSTEM_WEBM   OFF CACHE BOOL "" FORCE)

    set(SD_CUDA              OFF CACHE BOOL "" FORCE)
    set(SD_METAL             OFF CACHE BOOL "" FORCE)
    set(SD_VULKAN            OFF CACHE BOOL "" FORCE)
    set(SD_HIPBLAS           OFF CACHE BOOL "" FORCE)

    set(SD_OPENCL            OFF CACHE BOOL "" FORCE)
    set(SD_SYCL              OFF CACHE BOOL "" FORCE)
    set(SD_MUSA              OFF CACHE BOOL "" FORCE)

    set(SD_BUILD_EXAMPLES    OFF CACHE BOOL "" FORCE)
    set(SD_BUILD_TESTS       OFF CACHE BOOL "" FORCE)


    ## ─── CUDA : check if the compiler is available ───
    include(CheckLanguage)
    check_language(CUDA)
    if(CMAKE_CUDA_COMPILER)
        message(STATUS "CUDA compiler found: ${CMAKE_CUDA_COMPILER} → activate")
        set(SD_CUDA ON CACHE BOOL "" FORCE)
    else()
        message(STATUS "CUDA compiler not available → disabled")
    endif()

     # ─── Metal : macOS only ───
    if(APPLE)
        find_library(METAL_FRAMEWORK Metal QUIET)
        if(METAL_FRAMEWORK)
            message(STATUS "Metal found → enabled")
            set(SD_METAL ON CACHE BOOL "" FORCE)
        else()
            message(STATUS "Metal not found → disabled")
        endif()
    endif()

    # ─── Vulkan : verify the SDK ───
    find_package(Vulkan QUIET)
    if(Vulkan_FOUND)
        message(STATUS "Vulkan found → enabled")
        set(SD_VULKAN ON CACHE BOOL "" FORCE)
    else()
        message(STATUS "Vulkan SDK not found → disabled")
    endif()
    
    # ─── HIPBLAS : AMD ROCm ───
    find_program(HIPCC_EXECUTABLE hipcc)
    if(HIPCC_EXECUTABLE)
        message(STATUS "HIPCC found: ${HIPCC_EXECUTABLE} -> activate")
        set(SD_HIPBLAS ON CACHE BOOL "" FORCE)
    else()
        message(STATUS "HIPCC not found -> disabled")
    endif()

    # ─── SYCL : Intel oneAPI ───
    find_program(ICPX_EXECUTABLE icpx PATHS /opt/intel/oneapi/compiler/latest/linux/bin)
    if(ICPX_EXECUTABLE)
        message(STATUS "Intel SYCL compiler found: ${ICPX_EXECUTABLE} -> activate")
        set(SD_SYCL ON CACHE BOOL "" FORCE)
    else()
        message(STATUS "Intel SYCL compiler not found -> disabled")
    endif()

    # ─── Recap ───
    set(ACTIVE_BACKENDS "")
    if(SD_CUDA)
        set(ACTIVE_BACKENDS "${ACTIVE_BACKENDS} CUDA")
    endif()

    if(SD_METAL)
        set(ACTIVE_BACKENDS "${ACTIVE_BACKENDS} Metal")
    endif()

    if(SD_VULKAN)
        set(ACTIVE_BACKENDS "${ACTIVE_BACKENDS} Vulkan")
    endif()

    if(SD_HIPBLAS)
        set(ACTIVE_BACKENDS "${ACTIVE_BACKENDS} HIPBLAS")
    endif()

    if(SD_SYCL)
        set(ACTIVE_BACKENDS "${ACTIVE_BACKENDS} SYCL")
    endif()

    if(ACTIVE_BACKENDS STREQUAL "")
        set(ACTIVE_BACKENDS " CPU (no GPU)")
    endif()

    message(STATUS "Backends available :${ACTIVE_BACKENDS}")

    # stable-diffusion.cpp will search Vulkan, CUDA, etc.
    FetchContent_MakeAvailable(sd_cpp)

    # the target name is "sd" as defined in stable-diffusion.cpp's
    if(TARGET stable-diffusion)
        set(stable_diffusion_FOUND TRUE PARENT_SCOPE)
        set(stable_diffusion_VERSION "${SDCPP_BUILD_VERSION}" PARENT_SCOPE)
        message(STATUS "stable-diffusion.cpp found: ${SDCPP_BUILD_VERSION}")
    else()
        message(FATAL_ERROR "Failed to configure stable-diffusion.cpp via FetchContent.")
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
