FROM gcc:16.1.0

ENV DEBIAN_FRONTEND=noninteractive

# ==============================================================================
# System dependencies
# ==============================================================================
RUN apt-get update && apt-get install -y \
    build-essential \
    ninja-build \
    libvulkan-dev \
    glslc \
    spirv-headers \
    && rm -rf /var/lib/apt/lists/*

# ==============================================================================
# Install Python tool for Qt
# ==============================================================================
RUN pip3 install --break-system-packages aqtinstall

# ==============================================================================
# Install Qt framework
# ==============================================================================
RUN aqt install-qt linux desktop 6.10.2 --outputdir /opt/qt -m qtbase qtdeclarative qtquickcontrols2

ENV QT_DIR=/opt/qt/6.10.2/gcc_64

WORKDIR /app
