# Welcome to the Razorbotz NASA Lunabotics Project!
This page is intended to provide a starting point and overview of the project. It is also a roadmap for how to get involved with the project, even if you aren't familiar with the code or technology stack. Please note that these links may not be up to date and any links should be followed at your own risk. If you find any links that no longer work or changes that need to be made, please contact me at andrewburroughs17@gmail.com. Click [here](https://razorbotz.github.io/ROS2/) to view the documentation for the project. If you are not familiar with Github and the git cli, please refer to the [Razorbotz Github Intro page](https://github.com/Razorbotz/Test).

## Overview
* [Getting Started (Cloning the Code)](#getting-started-cloning-the-code)
* [Starting the Docker Environment](#starting-the-docker-environment)
* [Building and Running Examples](#building-and-running-examples)
* [Understanding the Codebase](#understanding-the-codebase)
* [Documentation](#documentation)
* [Tutorials](#tutorials)
* [Resources](#resources)

## Getting Started (Cloning the Code)
To begin the project, run the commands found in the [Install repository](https://github.com/Razorbotz/Install). This will install all dependencies and configure your environment to begin developing on the codebase. 

## Building and Running Examples

### Building the Code
Use the integrated terminal inside VS Code to compile your code.

**For the ROS 2 Workspace:**
```bash
cd /workspaces/RMC-Code-26-27/ROS2
colcon build --symlink-install
source install/setup.bash
```

**For the C++ Client:**
```bash
cd /workspaces/RMC-Code-26-27/C++/robotcontrollerclient/build
make -j$(nproc)
```

### Run Some Examples
To ensure your environment and GUI forwarding are working correctly, run the built-in ROS 2 Humble talker/listener nodes.

**Run the following commands in one VS Code terminal:**
```bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_cpp talker
```

**Open a second VS Code terminal (`Ctrl+Shift+\``) and run:**
```bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_py listener
```

## Understanding the Codebase
The codebase contains the code for our previous bots (Skinny, Spinner, Scoop) as well as the most recent rovers, Talos and Sisyphus. 

### Structure of the packages
ROS 2 packages all contain the following:
* `src/` folder // contains the source code / node files
* `CMakeLists.txt` // Defines dependencies for cmake 
* `package.xml` // Defines dependencies for ROS 2

The `src` folder within a package contains the `.cpp` files that define nodes and supporting files for classes/objects/functions relevant to that package. To read more about ROS 2 packages, please refer to the [ROS 2 tutorial](https://docs.ros.org/en/humble/Tutorials/Creating-Your-First-ROS2-Package.html).

The ROS 2 packages currently in this project are as follows:
* [Communication](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/communication2)
* [Excavation](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/excavation)
* [Falcon](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/falcon)
* [Logic](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/logic)
* [Power Distribution Panel](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/power_distribution_panel)
* [Talon](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/talon)
* [Video Streaming](https://github.com/Razorbotz/ROS2/tree/testing/shovel/video_streaming)
* [Zed Tracking](https://github.com/Razorbotz/ROS2/tree/testing/shovel/src/zed)

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
