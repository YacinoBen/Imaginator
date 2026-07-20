# Imaginator
Imaginator is a lightweight, local desktop application for AI image generation. Powered by modern C++20/23 and a fluid Qt6 QML chat interface, it runs models like Stable Diffusion, FLUX, etc., natively without Python or Docker overhead. Fast, private, fully cross-GPU compatible, with an automatic CPU fallback


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![C++](https://img.shields.io/badge/C++-20/23-blue.svg)](https://en.cppreference.com/w/cpp/20)
[![Qt](https://img.shields.io/badge/Qt-6-blue.svg)](https://doc.qt.io/qt-6/)

---

## 🎯 Goal

Imaginator provides an instant-start, low-memory footprint desktop experience powered directly by C++.

---

## ✨ Core Features

- **Conversational UI (Chat-like)**:  A seamless, dark-mode-first QML interface. Type a prompt, and the generated image appears in the chat thread (Txt2Img & Img2Img).
- **Cross-Vendor GPU Acceleration**: Powered by `stable-diffusion.cpp` with a primary focus on Vulkan, NVIDIA, AMD, Intel and a seamless CPU fallback for testing..
- **Smart Model Management**: Easily load `.safetensors` files locally. The app automatically detects the model architecture (SDXL, FLUX, etc.) and dynamically adjusts the UI parameters.
- **Strict Modular Architecture**: Complete separation between the pure C++ Core (inference, hardware detection) and the Qt UI layer, following SOLID principles.
---

## 🛠️ Technologies

Capture Moment is built for performance and modularity, using best-in-class libraries for each technical challenge.

|     Component    |      Technology     |                              Role                             |
|:----------------:|:-------------------:|:-------------------------------------------------------------:|
| Language         | C++20 / C++23       | Core Logic, Speed, and Control.                               |
| Build System     | CMake 4.2+         | Cross-platform build configuration.                           |
| AI Backend      | stable-diffusion.cpp        | Pure C/C++ inference engine (SD, FLUX, Qwen-Image).             |
| UI               | Qt6 Quick/QML      | Modern, declarative, and hardware-accelerated user interface. |


---

## 📋 Installation & Build

Imaginator supports Windows, macOS, and Linux. Due to the use of modern C++23 and Vulkan, specific SDKs are required.

For detailed, step-by-step instructions on setting up the Vulkan SDK, Qt, and compiling the project

[➡️ Read the full Build Guide](./docs/building/BUILDING_MAIN.md).

