can2piros
===============

.. contents:: Table of Contents
   :depth: 1

Initial Setup
--------
First the package must be built according to the instructions found under "ROS Noetic Installation" in the "Setup and Installation Guide". Then the workspace must be sourced, run the following command.

.. code-block:: bash

   source /devel/setup.bash

Now you are ready to use the can2piros ROS package.
      
Usage
---------
Run the following command to start collecting data from the can2piros package

.. code-block:: bash
		
   ./can_setup.sh
   rosrun obd2bridge obd_decode_node.py can0

Alternatively one can use the virtual can port for simulation. To simulate input, first in one terminal start the fake_car_node by running the command

.. code-block:: bash

   ./vcan_setup.sh
   rosrun obd2bridge fake_car_node.py

Now that the "car" is running you can start the decoder

.. code-block:: bash

   rosrun obd2bridge obd_decode_node.py vcan0


