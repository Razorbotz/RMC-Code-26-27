#!/bin/bash

if [[ -f /.dockerenv ]]; then
    SYS_ENV="docker"
else
    SYS_ENV="native"
fi

# Razorbotz Docker Development Helper Script
WORKSPACE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CPP_DIR="$WORKSPACE/C++/robotcontrollerclient"
ROS_DIR="$WORKSPACE/ROS2/shovel"
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

case "$1" in
    ""|--help)
        show_help
        ;;
 
    # Opens up the core files in VS Code
    --edit)
        cd "$CPP_DIR/src" || exit 1
        echo "[INFO] Opening files in VS Code..."
        code BinaryMessage.cpp control.cpp Speedometer.cpp ConfigDefinitions.cpp
        ;;
 
    # Launches the dashboard GUI
    --dash)
        cd "$CPP_DIR/build" || { echo "[ERROR] Run --build-cpp first!"; exit 1; }
        shift
        if [[ "$1" == "--sim" ]]; then
            shift
            echo "[INFO] Launching dashboard in sim mode (localhost)..."
            ./control --init --wsl "$@"
        else
            echo "[INFO] Launching dashboard..."
            ./control --init "$@"
        fi
        ;;
 
    # Smart C++ Build: Creates the folder if it doesn't exist, then compiles
    --build-cpp)
        echo "[INFO] Building C++ Client..."
        mkdir -p "$CPP_DIR/build"
        cd "$CPP_DIR/build" || exit 1
        cmake .. && make -j"$(nproc)"
        ;;
 
    # Compiles the ROS 2 workspace and accepts extra colcon arguments
    --build-ros)
        echo "[INFO] Building ROS 2 Workspace..."
        cd "$ROS_DIR" || exit 1
 
        if ! command -v colcon >/dev/null 2>&1; then
            echo "[ERROR] colcon not found. Source your ROS 2 install first, e.g.:"
            echo "        source /opt/ros/<distro>/setup.bash"
            exit 1
        fi
 
        # 'shift' removes "--build-ros" so the rest can be passed to colcon
        shift
        colcon build --symlink-install "$@" || exit 1
 
        echo "[INFO] Build complete. Run 'source $ROS_DIR/install/setup.bash' to use the workspace."
        ;;
 
    # Syncs submodules to the latest testing branch
    --update)
        echo "[INFO] Updating submodules from remote testing branches..."
        cd "$WORKSPACE" || exit 1
        git submodule update --remote
        ;;
 
    # Launches Gazebo and Foxglove WebSocket bridge
    --sim)
        cd "$ROS_DIR" || exit 1
 
        if [[ ! -f "install/setup.bash" ]]; then
            echo "[ERROR] You must run --build-ros first."
            exit 1
        fi
 
        source install/setup.bash
        shift
        echo "[INFO] Starting simulation..."
        # launch.py uses os.getcwd() to find sub-launch files, so it must run from $ROS_DIR
        ros2 launch launch/launch.py robot:=sim "$@"
        ;;
 
    --test)
        echo "test"
        ;;
 
    *)
        echo "[ERROR] Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac