#!/bin/bash

# ==============================================================================
# Imaginator - macOS Local Setup Script
# 
# This script automates the setup of the build environment for Imaginator.
# It installs the compiler, build tools via Homebrew.
# 
# WARNING: This script does NOT install Qt.
# Please make sure you have installed Qt manually (e.g., via the Qt Online 
# Installer or Homebrew) and set your CMAKE_PREFIX_PATH environment variable 
# accordingly before building the project.
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status

echo "=============================================================================="
echo " Imaginator - macOS Local Setup"
echo "=============================================================================="
echo ""

# ==============================================================================
# Check / Install Xcode Command Line Tools (Provides Clang, Metal, Git)
# ==============================================================================
if ! xcode-select -p &> /dev/null; then
    echo "[1/2] Installing Xcode Command Line Tools (required for Clang, Metal, Git)..."
    xcode-select --install
    echo "Please wait for the Xcode CLI tools installation to finish, then re-run this script."
    exit 0
else
    echo "[1/2] Xcode Command Line Tools are already installed."
fi

# ==============================================================================
# System dependencies (via Homebrew)
# ==============================================================================
echo "[2/2] Installing build tools via Homebrew (CMake, Ninja, ccache)..."
brew update
brew install cmake ninja ccache

echo ""
echo "=============================================================================="
echo " Setup completed successfully! You can now build Imaginator."
echo " Note: The Metal backend will be used automatically by stable-diffusion.cpp."
echo "       (No Vulkan SDK needed on macOS)."
echo "=============================================================================="
