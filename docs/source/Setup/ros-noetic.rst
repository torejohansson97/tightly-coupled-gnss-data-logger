ROS Noetic Installation
===============


.. contents:: Table of Contents
   :depth: 2
   :local:

Installation
-------------

To install ROS Noetic, we recommend you follow the instructions on the official `ROS wiki http://wiki.ros.org/noetic/Installation/Ubuntu>`_. 

.. warning::

   Remember, this installation guide is intended for systems running Ubuntu 20.04 (Focal Fossa). If you are running a different version of Ubuntu, you will need to follow the instructions for that version of Ubuntu. 
   Versions other than Ubuntu 20.04 have not been tested and are not supported.

We recommend you install the full desktop version of ROS Noetic using :

.. code-block:: bash

   sudo apt install ros-noetic-desktop-full

.. note::

   Do not forget to follow the instructions to initialize rosdep and to add the ROS environment variables to your ``~/.bashrc`` file.

Environment Setup
-------------

If you have not already completed the environmental setup step in the above installation guide, you will need to do so now.

Automatically source the setup script every time a new shell is launched. The following commands will do that for you.

.. code-block:: bash

   echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
   source ~/.bashrc

Create a ROS Workspace
-------------

You will need to create a ROS workspace in order to build packages from source. The steps are briefly outlined below. For more information, see the `ROS wiki http://wiki.ros.org/ROS/Tutorials/InstallingandConfiguringROSEnvironment#Create_a_ROS_Workspace>`_.

Install catkin tools

.. code-block:: bash

   sudo apt-get install ros-noetic-catkin python3-catkin-tools

Create and build a catkin workspace:

.. code-block:: bash

   mkdir -p ~/catkin_ws/src
   cd ~/catkin_ws/
   catkin build

For an empty worskpace, the command above should show the following output:

.. code-block:: bash

    [build] No packages were found in the source space '/home/master/catkin_ws/src'
    [build] No packages to be built.
    [build] Package table is up to date.                                                                                                                                                                                     
    Starting  >>> catkin_tools_prebuild                                                                                                                                                                                      
    Finished  <<< catkin_tools_prebuild                [ 1.0 seconds ]                                                                                                                                                       
    [build] Summary: All 1 packages succeeded!                                                                                                                                                                               
    [build]   Ignored:   None.                                                                                                                                                                                               
    [build]   Warnings:  None.                                                                                                                                                                                               
    [build]   Abandoned: None.                                                                                                                                                                                               
    [build]   Failed:    None.                                                                                                                                                                                               
    [build] Runtime: 1.0 seconds total.