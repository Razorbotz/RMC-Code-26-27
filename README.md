# Welcome to the Razorbotz NASA Lunabotics Project!
This page is intended to provide a starting point and overview of the project. It is also a roadmap for how to get involved with the project, even if you aren't familiar with the code or technology stack. Please note that these links may not be up to date and any links should be followed at your own risk. If you find any links that no longer work or changes that need to be made, please contact me at andrewburroughs17@gmail.com. Click [here](https://razorbotz.github.io/ROS2/) to view the documentation for the project. If you are not familiar with Github and the git cli, please refer to the [Razorbotz Github Intro page](https://github.com/Razorbotz/Test).

## Overview
* [Repository Layout](#repository-layout)
* [Getting Started](#getting-started)
* [The run.sh Helper](#the-runsh-helper)
* [Running the Simulation](#running-the-simulation)
* [Running on the Robot](#running-on-the-robot)
* [Building Manually](#building-manually)
* [Run Some Examples](#run-some-examples)
* [Understanding the Codebase](#understanding-the-codebase)
* [Documentation](#documentation)
* [Tutorials](#tutorials)
* [Resources](#resources)
* [Troubleshooting](#troubleshooting)

## Repository Layout
The project is split into two repositories, which the install script clones side by side into `~/SoftwareDevelopment`:

```
~/SoftwareDevelopment/
├── run.sh                        # helper script for building, simulating, and driving
├── ROS2/                         # github.com/Razorbotz/ROS2 – robot software
│   └── shovel/                   # ROS 2 workspace: launch/ and all packages in src/
└── C++/                          # github.com/Razorbotz/CPP – operator station
    └── robotcontrollerclient/    # the "control" GUI
```

* **ROS 2 workspace (`ROS2/shovel`)** – everything that runs on the robot's onboard computers or in the Gazebo simulation. See the [ROS2 README](https://github.com/Razorbotz/ROS2/tree/testing) for launch arguments and per-robot details.
* **Control client (`C++/robotcontrollerclient`)** – the operator station that shows video and telemetry and sends joystick commands to the robot. See the [CPP README](https://github.com/Razorbotz/CPP/tree/testing) for all command-line flags and controls.

Both repos are checked out on the `testing` branch; `master` is also available locally.

## Getting Started
Development is done in **Ubuntu 22.04 on WSL** (Windows Subsystem for Linux) with **ROS 2 Humble**. If you're already on Ubuntu 22.04, skip step 1.

### 1. Install WSL
In a Command Prompt or PowerShell on Windows, run:

```
wsl --install Ubuntu-22.04
```

When it finishes, create a username and password, then open the Ubuntu terminal. Run every command below inside Ubuntu, not in PowerShell.

### 2. Run the install script
```bash
cd ~
git clone https://github.com/Razorbotz/Install.git
cd Install
chmod +x setup_wsl.sh
./setup_wsl.sh
```

> **Do not run it with `sudo ./setup_wsl.sh`.** That makes your project folders owned by root and causes permission errors later. Run it normally and type your password when it asks.

The script takes a while. It:
* clones the ROS2 and CPP repos into `~/SoftwareDevelopment` (on the `testing` branch),
* installs the CTRE motor controller libraries into `/usr/local`,
* installs ROS 2 Humble, Gazebo 11, Foxglove Bridge, and every library the control client needs,
* builds the control client,
* adds three lines to your `~/.bashrc`: ROS 2 setup, tab-completion for `control`, and `GAZEBO_MODEL_PATH` for the simulation models.

When it's done, remove the installer and **close and reopen the terminal** so the `~/.bashrc` changes take effect:

```bash
cd ~ && rm -rf ~/Install
```

### 3. Build the ROS 2 workspace
The install script builds the control client but not the ROS 2 workspace. Build it now:

```bash
cd ~/SoftwareDevelopment
./run.sh --build-ros
```

### 4. Try it out
Check your setup with the [talker/listener example](#run-some-examples), then run [the simulation](#running-the-simulation).

### Getting the latest code
Pull each repo when you start working:

```bash
cd ~/SoftwareDevelopment/ROS2 && git pull
cd ~/SoftwareDevelopment/C++ && git pull
```

Then rebuild whichever side changed (`./run.sh --build-ros` or `./run.sh --build-cpp`).

## The run.sh Helper
`run.sh` sits at the top of `~/SoftwareDevelopment`, next to the `ROS2` and `C++` folders, and works from any directory (it finds those folders from its own location).

| Command | What it does |
|---|---|
| `./run.sh --help` | Show the command list |
| `./run.sh --update` | `git submodule update --remote`. Only works if `~/SoftwareDevelopment` is a checkout of the parent repo with submodules; with the install script's layout, `git pull` each repo instead (see [Getting the latest code](#getting-the-latest-code)) |
| `./run.sh --build-cpp` | Create `C++/robotcontrollerclient/build` if needed, then `cmake .. && make` |
| `./run.sh --build-ros [colcon args]` | `colcon build --symlink-install` in `ROS2/shovel`. Extra arguments go to colcon |
| `./run.sh --sim [launch args]` | Source the workspace and launch the full stack with `robot:=sim`. Extra arguments go to the launch file |
| `./run.sh --dash [flags]` | Start the control client with `--init`. Extra arguments go to `control` |
| `./run.sh --dash --sim [flags]` | Start the control client with `--init --wsl` so it connects to a simulation on this machine |
| `./run.sh --edit` | Open the core control client files in VS Code (needs VS Code with the WSL extension) |

Some useful combinations:

```bash
# Skip the ZED package (needs the ZED SDK, which isn't in every environment)
./run.sh --build-ros --packages-ignore zed_tracking

# Rebuild just one package
./run.sh --build-ros --packages-select logic

# Simulation with the Foxglove bridge and without telemetry recording
./run.sh --sim use_foxglove:=true enable_recording:=false

# Control client for the dump bot with motor packet debugging
./run.sh --dash --dump_bot --debug_motors
```

`--build-ros` needs ROS on your path. The install script adds `source /opt/ros/humble/setup.bash` to your `~/.bashrc`, so this works in any new terminal.

## Running the Simulation
You need two terminals, both at the repo root.

**Terminal 1 – start the simulated robot:**
```bash
./run.sh --sim
```
This starts Gazebo, the simulated motors, AprilTag localization, and the same autonomy, logic, communication, drivetrain, and video nodes the real robot runs.

**Terminal 2 – start the control client:**
```bash
./run.sh --dash --sim
```
Click **Connect**, then drive with a joystick or controller exactly as you would at competition.

**Optional: keyboard driving instead of the control client.** In a second terminal:
```bash
cd ~/SoftwareDevelopment/ROS2/shovel
source install/setup.bash
ros2 run teleop keyboard_control
```

**Optional: Foxglove.** Start the sim with `./run.sh --sim use_foxglove:=true` and connect [Foxglove Studio](https://foxglove.dev/) to `ws://localhost:8765`. The control client also runs a Foxglove server on port 8765, so start it with `./run.sh --dash --sim --disable_foxglove` to avoid a port clash.

## Running on the Robot
The current rovers are **Talos**, **Sierra**, and **Sisyphus**.

**On the robot** (over SSH to the Orin or Nano):
```bash
cd ~/SoftwareDevelopment/ROS2/shovel
source install/setup.bash
ros2 launch launch/launch.py robot:=sierra     # or talos / sisyphus
```
Add `role:=nano` when running on the Jetson Nano. The launch file must be started from `ROS2/shovel` because it finds its sub-launch files relative to the current directory.

**On the operator laptop:**
```bash
./run.sh --dash
```
Add the control client's bot flag for the robot you're driving (see the control client README). The client connects to the Orin at `192.168.0.6` and the Nano at `192.168.0.5` by default.

## Building Manually
`run.sh` is the easiest way to build, but the equivalent commands are:

**ROS 2 workspace:**
```bash
cd ~/SoftwareDevelopment/ROS2/shovel
colcon build --symlink-install
source install/setup.bash
```

**Control client:**
```bash
cd ~/SoftwareDevelopment/C++/robotcontrollerclient
mkdir -p build && cd build
cmake ..
make -j$(nproc)
```

Run `source install/setup.bash` in every new terminal before using any `ros2` command with this workspace. Run the control client from its `build/` folder, since it loads its layouts from `../resources/`.

## Run Some Examples
To ensure ROS 2 is installed correctly, run the built-in ROS 2 Humble talker/listener nodes.

**Run the following in one Ubuntu terminal:**
```bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_cpp talker
```

**Open a second Ubuntu terminal and run:**
```bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_py listener
```

The listener should print each message the talker sends.

## Understanding the Codebase
The codebase contains the code for our previous bots (Skinny, Spinner, Scoop, and Shovel) as well as the current rovers, Talos, Sierra, and Sisyphus.

### Structure of the packages
ROS 2 packages all contain the following:
* `src/` folder // contains the source code / node files
* `CMakeLists.txt` // Defines dependencies for cmake
* `package.xml` // Defines dependencies for ROS 2

The `src` folder within a package contains the `.cpp` files that define nodes and supporting files for classes/objects/functions relevant to that package. To read more about ROS 2 packages, please refer to the [ROS 2 tutorial](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-Your-First-ROS2-Package.html).

### Packages
All packages live in `ROS2/shovel/src/`:

| Package | Purpose |
|---|---|
| [apriltag](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/apriltag) | AprilTag detection and localization |
| [autonomy](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/autonomy) | Autonomous navigation |
| [communication](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/communication) | Link to the operator station: telemetry out, joystick commands in |
| [drivetrain](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/drivetrain) | Drivetrain control |
| [excavation](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/excavation) | Arm and bucket control |
| [falcon](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/falcon) | Falcon 500 motor controller nodes |
| [kraken](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/kraken) | Kraken X60 motor controller nodes |
| [talon](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/talon) | Talon SRX motor controller nodes |
| [motors](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/motors) | Shared motor configuration, including simulated motors |
| [lidar](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/lidar) | Lidar driver |
| [logic](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/logic) | Turns operator commands into motor commands |
| [messages](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/messages) | Custom ROS 2 message definitions |
| [perception](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/perception) | Lunar perception from the depth camera point cloud |
| [power_distribution_panel](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/power_distribution_panel) | Power distribution panel monitoring |
| [sim](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/sim) | Gazebo simulation world and robot models |
| [status_monitor](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/status_monitor) | System health monitoring |
| [teleop](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/teleop) | Keyboard teleoperation for the simulation |
| [utils](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/utils) | Shared helper code |
| [video_streaming](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/video_streaming) | Camera stream to the operator station |
| [zed_tracking](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/zed_tracking) | ZED camera position tracking |

Each subsystem is started by its own file in `ROS2/shovel/launch/`, and `launch.py` picks which ones to run based on the `robot` argument. The ROS2 README has a table of what starts on each robot.

### Legacy node diagram
The diagram below shows the node relationships from the 2023–24 Shovel robot. It is kept for reference; the current rovers add autonomy, perception, status monitoring, and recording nodes not shown here.

![Node Relationship Visual](docs/images/Nodes23-24.png)

All motor controller nodes, i.e., Talon, Falcon, and Excavation nodes, also subscribe to two publishers from the communication node that are called the GO and STOP publishers. These subscriptions were omitted from the diagram for the sake of clarity.

## Documentation
This project uses [Doxygen](https://www.doxygen.nl/index.html) to generate documentation for the files automatically. **To make documentation easier for all users, Doxygen is hosted on the Github and does not need to be downloaded by contributors.** To learn more about the Doxygen formatting, please refer to the [Documenting the code](https://www.doxygen.nl/manual/docblocks.html) section of the Doxygen docs. The documentation for this project can be found at the project website that is found [here](https://razorbotz.github.io/ROS2/).

### Documentation Template
To standardize the documentation across multiple authors, the following documentation template will be used throughout the project. To see an example of how files should be commented to generate the documentation correctly, see [Example.cpp](https://github.com/Razorbotz/ROS2/blob/testing/docs/Example.cpp). To view the documentation generated for the Example.cpp file, please click [here](https://razorbotz.github.io/ROS2/Example_8cpp.html).

**Files**
* Description of file
* Topics subscribed to
* Topics published
* Related files

**Functions**
* Description of Function
* Parameters
* Return values
* Related files and/or functions

## Tutorials
*Note: We are currently using ROS 2 Humble. Always ensure you are reading the Humble documentation, not Foxy or Galactic.*

To gain a better understanding of ROS 2, please refer to the following [tutorials](https://docs.ros.org/en/humble/Tutorials.html).
* [Configuring Your ROS 2 Environment](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Configuring-ROS2-Environment.html)
* [Understanding ROS 2 Nodes](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Nodes/Understanding-ROS2-Nodes.html)
* [Understanding ROS 2 Topics](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Topics/Understanding-ROS2-Topics.html)
* [Understanding ROS 2 Parameters](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Parameters/Understanding-ROS2-Parameters.html)
* [Creating a Workspace](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html)
* [Creating a Package](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-Your-First-ROS2-Package.html)
* [Writing a Simple Publisher and Subscriber (C++)](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Writing-A-Simple-Cpp-Publisher-And-Subscriber.html)
* [Writing a Simple Publisher and Subscriber (Python)](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Writing-A-Simple-Py-Publisher-And-Subscriber.html)
* [Writing Custom ROS 2 msg Files](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Custom-ROS2-Interfaces.html)
* [Using Parameters in a Class (C++)](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Using-Parameters-In-A-Class-CPP.html)
* [Using Parameters in a Class (Python)](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Using-Parameters-In-A-Class-Python.html)
* [Creating Launch Files](https://docs.ros.org/en/humble/Tutorials/Intermediate/Launch/Creating-Launch-Files.html)

## Resources
General Reference Material:
* [Coding Standards for C++](http://web.mit.edu/6.s096/www/standards.html)

Hardware Documentation:
* [Talon Documentation](https://store.ctr-electronics.com/content/api/cpp/html/index.html)

C++ Reference Material:
* [C++ Namespaces (sets 1 - 3)](https://www.geeksforgeeks.org/namespace-in-c/)
* [C++ Operators reference](https://www.cplusplus.com/doc/tutorial/operators/)
* [C++ Member Access Refresher](https://en.cppreference.com/w/cpp/language/operator_member_access)

## Troubleshooting
* **`colcon not found`** – ROS isn't sourced in this terminal. Run `source /opt/ros/humble/setup.bash`.
* **`You must run --build-ros first`** – the workspace hasn't been built yet; run `./run.sh --build-ros`.
* **`Run --build-cpp first!`** – the control client hasn't been built yet; run `./run.sh --build-cpp`.
* **`zed_tracking` fails to build** – the ZED SDK isn't installed; build with `./run.sh --build-ros --packages-ignore zed_tracking`.
* **Control client can't connect to the sim** – make sure you used `./run.sh --dash --sim` (not plain `--dash`), and that the sim's network interface matches; the sim's comm and video nodes bind to `eth1` (check yours with `ip a`).
* **Foxglove port 8765 already in use** – the sim's Foxglove bridge and the control client both use 8765; add `--disable_foxglove` to the `--dash` command.
* **No GUI windows appear (Gazebo, control client)** – WSL shows Linux windows through WSLg, which needs Windows 10 21H2+ or Windows 11. In PowerShell run `wsl --update`, then `wsl --shutdown`, and reopen Ubuntu.
* **`ros2: command not found`** – the terminal was opened before the install script finished. Close and reopen it, or run `source ~/.bashrc`.
* **Permission denied in `~/SoftwareDevelopment`** – the install script was run with `sudo`. Fix ownership with `sudo chown -R $USER:$USER ~/SoftwareDevelopment`.
* **Gazebo can't find the arena models** – `GAZEBO_MODEL_PATH` isn't set. Check that `~/.bashrc` has the line the install script adds, then reopen the terminal.