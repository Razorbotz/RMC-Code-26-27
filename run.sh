#!/bin/bash

if [[ -f /.dockerenv ]]; then
    SYS_ENV="docker"
else
    SYS_ENV="native"
fi

# Razorbotz Docker Development Helper Script
WORKSPACE="/workspaces/SoftwareDevelopment"
CPP_DIR="$WORKSPACE/C++/robotcontrollerclient"
ROS_DIR="$WORKSPACE/ROS2"

show_help() {
    echo "Razorbotz RMC Development Helper"
    echo "Usage: ./run.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  --edit       : Opens core C++ control files in VS Code."
    echo "  --dash       : Launches the dashboard GUI."
    echo "  --build-cpp  : Compiles the C++ robot controller client."
    echo "  --build-ros  : Compiles the ROS 2 workspace (Accepts extra colcon flags like --packages-ignore zed_tracking)."
    echo "  --update     : Pulls the latest testing branch for all submodules."
    echo "  --sim        : Launches Gazebo simulation and Foxglove bridge."
    echo "  --help       : Shows this menu."
    echo "  --test       : TEST"
}

# Show help menu if no arguments are passed
if [[ "$1" == "" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Opens up the core files in the host's VS Code window
if [[ "$1" == "--edit" ]]; then
    cd "$CPP_DIR/src" || exit 1
    echo "[INFO] Opening files in VS Code..."
    code BinaryMessage.cpp control.cpp Speedometer.cpp ConfigDefinitions.cpp
fi

# Opens up the dashboard GUI via X11 forwarding
if [[ "$1" == "--dash" ]]; then
    cd "$CPP_DIR/build" || { echo "Run --build-cpp first!"; exit 1; }
    echo "[INFO] Launching dashboard..."
    ./control --init
fi

# Smart C++ Build: Creates the folder if it doesn't exist, then compiles
if [[ "$1" == "--build-cpp" ]]; then
    echo "[INFO] Building C++ Client..."
    mkdir -p "$CPP_DIR/build"
    cd "$CPP_DIR/build" || exit 1
    cmake ..
    make -j$(nproc)
fi

# Compiles the ROS 2 workspace and accepts extra colcon arguments
if [[ "$1" == "--build-ros" ]]; then
    echo "[INFO] Building ROS 2 Workspace for $SYS_ENV environment..."
    cd "$ROS_DIR" || exit 1
    
    # 'shift' removes the "--build-ros" argument so we can pass the rest to colcon
    shift 
    
    colcon build \
        --build-base "build_$SYS_ENV" \
        --install-base "install_$SYS_ENV" \
        --log-base "log_$SYS_ENV" \
        --symlink-install "$@"
    
    echo "[INFO] Build complete. Run 'source install_$SYS_ENV/setup.bash' to use the workspace."
fi

# Automatically syncs both submodules to the latest testing branch
if [[ "$1" == "--update" ]]; then
    echo "[INFO] Updating submodules from remote testing branches..."
    cd "$WORKSPACE" || exit 1
    git submodule update --remote
fi

# Launches Gazebo and Foxglove WebSocket bridge
if [[ "$1" == "--sim" ]]; then
    cd "$ROS_DIR" || exit 1
    
    # Check if the workspace has been built
    if [ ! -f "install/setup.bash" ]; then
        echo "[ERROR] You must run --build-ros first."
        exit 1
    fi
    
    source install/setup.bash
    
    echo "[INFO] Starting Gazebo Simulation..."
    ros2 launch sim artemis_sim.launch.py
fi

if [[ "$1" == "--test" ]]; then
    echo "test"
fi
