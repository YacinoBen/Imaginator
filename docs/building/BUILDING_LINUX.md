# 🐧 Linux Building Guide
This guide covers building Imaginator on Linux. The recommended method uses an automated script to install the required system tools and GPU SDKs, ensuring you get a setup that perfectly matches our CI pipeline.

## 📦 Setting up Dependencies (Recommended) on Ubuntu/Debian

### 1. Run the automated setup script
This script installs the base compiler toolchain, CMake, Ninja, and the Vulkan SDK (which is required for hardware-accelerated AI inference via stable-diffusion.cpp).

From the root of the project, run:

```bash
chmod +x setup/setup-ubuntu.sh
./setup/setup-ubuntu.sh
```
(Note: You can look inside this script if you prefer to run the installation steps manually).

## 🚀Build the project
* You can omit -DBUILD_DESKTOP_UI=ON if you don't want to compile the UI.
* You can swap release-ninja for debug-ninja (or any other preset from the table below).

```bash
# Configure the project using a generic preset and enable the Desktop UI
cmake --preset release-ninja -DBUILD_DESKTOP_UI=ON

# Or, for a debug build:
# cmake --preset debug-ninja -DBUILD_DESKTOP_UI=ON

# Compile using all available CPU cores
cmake --build build/release-ninja -j$(nproc) # Adjust path if using debug preset
```

### Alternative Build Commands

Since dependencies are installed system-wide (in /opt/ or /usr/local/), we use generic presets.

```bash
# Configure in Debug and enable the UI
cmake --preset debug -Ddesktop_ui=ON

# Compile using all available cores
cmake --build build/debug -j$(nproc)
```

---
## 🔍 Available Linux Presets

|  Preset Name |    Generator   | Build Type |                       Notes                      |
|:------------:|:--------------:|:----------:|:------------------------------------------------:|
| default      | Auto-detect    | Debug      | Auto-detects the generator (Ninja or Makefiles). |
| debug        | Auto-detect    | Debug      | Base preset for development.                     |
| release      | Auto-detect    | Release    | Optimized build.                                 |
| debug-ninja  | Ninja          | Debug      | Ninja generator for fast build (recommended).    |
| release-ninja| Ninja          | Release    | Ninja generator for fast build (recommended).    |
| release-make | Unix Makefiles | Release    | Classic Makefiles generator.                     |
| debug-make   | Unix Makefiles | Debug      | Classic Makefiles generator.                     |
| release-ninja-linux | Ninja | Release    | Classic Makefiles generator.                     |
| debug-ninja-linux  | Ninja | Debug      | Classic Makefiles generator.                     |