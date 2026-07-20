#!/bin/bash

# ==============================================================================
# Imaginator - Linux Local Setup Script
# 
# This script automates the setup of the build environment for Imaginator.
# It installs the compiler, build tools, and the Vulkan SDK.
# 
# WARNING: This script does NOT install Qt.
# Please make sure you have installed Qt manually and set your CMAKE_PREFIX_PATH
# environment variable accordingly before building the project.
# ==============================================================================

echo "=============================================================================="
echo " Imaginator - Linux Local Setup"
echo "=============================================================================="
echo ""

# ==============================================================================
# System dependencies
# ==============================================================================
echo "[1/2] Installing system dependencies (CMake, Ninja, GCC, ccache)..."
sudo apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    ccache \
    git \
    && rm -rf /var/lib/apt/lists/*


# ==============================================================================
# Vulkan SDK
# ==============================================================================
echo "[2/2] Installing Vulkan SDK (Headers, Glslc, SPIR-V)..."
sudo apt-get update && apt-get install -y \
    libvulkan-dev \
    glslc \
    spirv-headers \
    && rm -rf /var/lib/apt/lists/*

echo ""
echo "=============================================================================="
echo " Setup completed successfully! You can now build Imaginator."
echo "=============================================================================="

echo "Setup completed successfully! You can now build Imaginator."
