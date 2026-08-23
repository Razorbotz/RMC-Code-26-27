# Start with the official ZED SDK image (includes Ubuntu 22.04, CUDA 12.1, and OpenGL support for GUIs)
FROM stereolabs/zed:4.1-gl-devel-cuda12.1-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 1. Setup ROS 2 Humble Repository
RUN apt-get update && apt-get install -y software-properties-common curl gnupg lsb-release locales && \
    locale-gen en_US en_US.UTF-8 && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 2. Install ROS 2 Desktop, Control, and Aruco packages
RUN apt-get update && apt-get install -y \
    ros-humble-desktop \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-aruco-ros \
    && rm -rf /var/lib/apt/lists/*

# 3. Install Build Dependencies (OpenCV, GTK, Qt5, etc.)
RUN apt-get update && apt-get install -y \
    build-essential cmake pkg-config \
    python3 python3-dev python3-pip python3-numpy \
    libprotoc-dev protobuf-compiler libprotobuf-dev \
    libqt5core5a libqt5gui5 libqt5opengl5 libqt5widgets5 qtbase5-dev \
    libogre-1.9-dev libbullet-dev \
    libboost-all-dev \
    libtinyxml-dev libtinyxml2-dev \
    libfreeimage-dev \
    libcurl4-openssl-dev libtbb-dev libgts-dev libusb-1.0-0-dev \
    libxi-dev libxmu-dev libzip-dev libtar-dev \
    libeigen3-dev freeglut3-dev doxygen \
    libopencv-dev python3-opencv \
    libgtkmm-3.0-dev libsdl2-dev \
    zlib1g-dev libcairo2-dev \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev \
    nlohmann-json3-dev \
    libwebsocketpp-dev libasio-dev \
    git wget curl \
    && rm -rf /var/lib/apt/lists/*

# 4. Set up Environment Variables
ENV GAZEBO_MODEL_PATH="/workspaces/${localWorkspaceFolderBasename}/ROS2/shovel/src/sim/models:${GAZEBO_MODEL_PATH:-}"

# 5. Add source scripts to bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source /workspaces/RMC-Code-25-26/C++/robotcontrollerclient/control_completion.sh" >> /root/.bashrc

CMD ["bash"]