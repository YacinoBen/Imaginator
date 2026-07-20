### `docs/BUILDING_MAIN.md`
*The main entry point for build instructions.*


# 🚀 Build Guide - Imaginator

Welcome! This guide will help you build Imaginator from source.

## 🧰 Global Prerequisites

Before selecting your platform, ensure you have these tools:

1.  **CMake 4.2+**
2.  **C++23 Compiler**:
    * **Windows**: MSVC 2026 or MinGW (GCC 16+).
    * **Linux**: GCC 16+
    * **macOS**: Apple Clang 16+ (Xcode 15+).

---
## ⚙️ Global Build Configuration

### CMake Build
|  Component | Default Status |     CMake Variable (Alias)    |                  Description                  |
|:----------:|:--------------:|:-----------------------------:|:---------------------------------------------:|
| Desktop UI | OFF            | BUILD_DESKTOP_UI (desktop_ui) | Builds the Qt Quick/QML desktop application.  |
| Tests      | OFF            | BUILD_TESTS (tests)           | Builds unit and integration tests.            |

### Libraries

| Library     | Version      | Link                                                     |
|-------------|:------------------:|----------------------------------------------------------|
| stable-diffusion.cpp | master (latest)             | https://github.com/leejet/stable-diffusion.cpp |
| spdlog      | 1.17.0      | https://github.com/gabime/spdlog                         |
|  Qt6           | 6.10.x| https://doc.qt.io/qt-6/

---
## 📦 How to build

### 1. Setup Qt (Optional - Required for Desktop UI)
If you want to build the Desktop UI. Please follow the dedicated guide to install `Qt` on your machine:  [➡️ Read the Building Qt Guide](INSTALLATION_QT.md).

### 2. GPU Backend (Optional but Recommended)
Imaginator supports multiple GPU backends via stable-diffusion.cpp. By default, it will fallback to CPU if no SDK is found. Install the SDK that matches your hardware for hardware acceleration:

#### 🟦 Vulkan (Windows & Linux - Default recommendation)
The Linux setup script installs this automatically.

* [🟦 **Windows SDK Download**](https://vulkan.lunarg.com/sdk/home).
  
#### 🟢 NVIDIA CUDA
* [🟦 **CUDA Toolkit Download**](https://developer.nvidia.com/cuda/toolkit).

#### 🔴 AMD (ROCm / HIP)
* [**HIP SDK  Windows Download**](https://www.amd.com/fr/developer/resources/rocm-hub/hip-sdk.html).
* [**ROCm Linux Installation Guide**](https://rocm.docs.amd.com/en/latest/install/rocm.html?fam=all&w=graphics&os=windows&windows-ver=11&i=pip).

#### 🔵 Intel (oneAPI / SYCL)
* [**oneAPI Toolkit Download**](https://www.intel.com/content/www/us/en/developer/tools/oneapi/oneapi-toolkit-download.html).

#### 🍎 Apple Metal (macOS only)
No installation required. Metal is automatically detected and used if Xcode Command Line Tools are installed.

### 3. Setup Dependencies & Compile
Click the link for your OS for detailed instructions:

* [🟦 **Windows**](./guidelines/BUILDING_WINDOWS.md).
* [🐧 **Linux**](./guidelines/BUILDING_LINUX.md) (Ubuntu, Fedora, Arch).
* [🍎 **macOS**](./guidelines/BUILDING_MACOS.md) (Homebrew and Xcode).
