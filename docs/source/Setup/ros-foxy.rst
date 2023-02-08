ROS Foxy Installation
===============

.. contents:: Table of Contents
   :depth: 1
   :local:

This document explains how to install ROS Foxy on your system. Keep in mind that ROS Foxy is a distribution of ROS2 where the previously installed ROS Noetic 
is a ROS1 distribution. The purpose of the hetrogenous installation is to allow the user to use both ROS1 and ROS2 on the same system, and for logging 
to use the updated ROS2 logging system.

.. warning::
   This is a work in progress. These instructions have not yet been tested fully.

Installation
-------------

To install ROS Foxy, we recommend you follow the instructions on the official `documentation https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html>`_.

We recommend you install the full desktop version of ROS Foxy using :

.. code-block:: bash

   sudo apt install ros-foxy-desktop python3-argcomplete

ROS1 Bridge
-------------

In the previously mentioned documentation, you will find instructions on how to install the ROS1 bridge. This is necessary for the logging system.

Assuming you have already installed both neotic and foxy, you can continue the install process.

Clone the ros1 bridge in your ros2 workspace

.. code-block:: bash

   mkdir -p ~/bridge_ws/src
   cd ~/bridge_ws/src
   git clone https://github.com/ros2/ros1_bridge
   cd ros1_bridge
   git switch foxy

Export your ROS1 and ROS2 installation paths

.. code-block:: bash

   export ROS1_INSTALL_PATH=/opt/ros/noetic
   export ROS2_INSTALL_PATH=/opt/ros/foxy

Build your ROS1 packages (make sure you don't have your ROS2 sourced in this terminal, check your ~/.bashrc if you are unsure)

.. code-block:: bash

   cd ~/catkin_ws
   source ${ROS1_INSTALL_PATH}/setup.bash
   catkin_make

In a new terminal, build your ROS2 packages (make sure you don't have your ROS1 sourced, check your ~/.bashrc if you are unsure)

.. code-block:: bash

   cd ~/ros2_ws
   source ${ROS2_INSTALL_PATH}/setup.bash
   colcon build --symlink-install

In the same terminal, build the ROS1 bridge from source

.. code-block:: bash

   cd ~/ros2_ws
   source ${ROS1_INSTALL_PATH}/setup.bash
   source ${ROS2_INSTALL_PATH}/setup.bash
   source ~/catkin_ws/devel/setup.bash
   source ~/ros2_ws/install/setup.bash
   colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure