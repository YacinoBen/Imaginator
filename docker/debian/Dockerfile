FROM gcc:16.1.0

ENV DEBIAN_FRONTEND=noninteractive

# ==============================================================================
# System dependencies
# ==============================================================================
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-pip \
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
RUN aqt install-qt linux desktop 6.10.2 --outputdir /opt/qt -m qtdeclarative

WORKDIR /app
