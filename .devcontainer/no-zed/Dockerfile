# Use the official ROS 2 Humble Desktop image (includes Gazebo 11, RViz, and GUI tools)
FROM osrf/ros:humble-desktop

# Prevent interactive prompts during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install ROS 2 Control and Aruco packages
RUN apt-get update && apt-get install -y \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-aruco-ros \
    && rm -rf /var/lib/apt/lists/*

# Install C++, Python, OpenCV, GTK, Qt5, and other build dependencies
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
    nlohmann-json3-dev \
    libwebsocketpp-dev libasio-dev \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev \
    git wget curl \
    && rm -rf /var/lib/apt/lists/*

# COPY custom CTRE libraries into the image
COPY Dependencies/ctre /usr/local/include/ctre
COPY Dependencies/lib/x86_64/* /usr/local/lib/

# Set up environment variables
# VS Code mounts the repository to /workspaces/<repo-name> by default
ENV GAZEBO_MODEL_PATH="/workspaces/${localWorkspaceFolderBasename}/ROS2/shovel/src/sim/models:${GAZEBO_MODEL_PATH:-}"

# Add source scripts to bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source /workspaces/RMC-Code-25-26/C++/robotcontrollerclient/control_completion.sh" >> /root/.bashrc

# Default command
CMD ["bash"]