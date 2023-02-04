ROS Foxy Installation
===============

.. contents:: Table of Contents
   :depth: 1
   :local:

This document explains how to install ROS Foxy on your system. Keep in mind that ROS Foxy is a distribution of ROS2 where the previously installed ROS Noetic 
is a ROS1 distribution. The purpose of the hetrogenous installation is to allow the user to use both ROS1 and ROS2 on the same system, and for logging 
to use the updated ROS2 logging system.

Installation
-------------

To install ROS Foxy, we recommend you follow the instructions on the official `documentation https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html>`_.

We recommend you install the full desktop version of ROS Noetic using :

.. code-block:: bash

   sudo apt install ros-foxy-desktop python3-argcomplete

ROS1 Bridge
-------------

In the previously mentioned documentation, you will find instructions on how to install the ROS1 bridge. This is necessary for the logging system.

Assuming you have already installed both neotic and foxy, you can continue the install process.

Clone the ros1 bridge in your ros2 workspace

.. code-block:: bash

   cd ~/ros2_ws/src
   git clone https://github.com/ros2/ros1_bridge
   cd ros1_bridge
   git switch foxy

Source your ROS1 and ROS2 installation paths

.. code-block:: bash

   export ROS1_INSTALL_PATH=/opt/ros/noetic
   export ROS2_INSTALL_PATH=/opt/ros/foxy

Build your ROS2 packages

.. code-block:: bash

   cd ~/ros2_ws
   colcon build --symlink-install --packages-skip ros1_bridge

Source your ROS1 installation path and ROS1 packages to account for custom messages

.. code-block:: bash

   source ${ROS1_INSTALL_PATH}/setup.bash
   source /home/master/catkin_ws/devel/setup.bash

Build the ROS1 bridge from source

.. code-block:: bash

   cd ~/ros2_ws
   colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure

Running the bridge
^^^^^^^^^
