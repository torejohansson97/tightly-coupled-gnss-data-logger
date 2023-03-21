Inertial platform
=========================
.. contents:: Table of Contents
	:depth: 1
	:local:

The Tightly Coupled GNSS Data Logger includes two inertial platforms. They are
based on the `Xsens
MTI-3 <https://www.movella.com/products/sensor-modules/xsens-mti-3-ahrs>`_ and
`BerryGPS-IMU v4 <https://ozzmaker.com/product/berrygps-imu/>`_ respectivly. They
provide inertial measurement and attitude estimate at 100 Hz that are published
to the ROS network. The inertial units are located on the third level in the
data logger.

Xsens MTI-3 AHRS
----------------
Hardware
^^^^^^^^^^^^^^
The Xsens MTI-3 is a fully integrated Attitude and Heading Reference System 
(AHRS) delivered as a system on a module. It is mounted on a custom carrier
board made to interface with a Raspberry Pi (4). Gerber files for the PCB is
available in the repository. The PCB is designed to enable a multitude of
communication options. The MTI-3 can be connected either by a USB cable (via a
USB-to-Serial adapter on board), directly to the serial port of the Raspberry Pi
or alternatively with SPI (not tested).

Software
^^^^^^^^^^^^^
The software to used to connect the MTI-3 to the ROS network is supplied by
Xsense in their `SDK. <https://www.movella.com/support/software-documentation>`_

BerryGPS-IMU v4
----------------
Hardware
^^^^^^^^^^^^^
The BerryGPS-IMU is a hardware platform developed by Ozzmakers for Attitude and
Position estimation. It is designed to for Raspberry Pi and includes a range of
sensors. Data from the sensors are either read from an I2C bus, SPI bus or UART.

Software
^^^^^^^^^^^^^
Since the BerryGPS-IMU does not include any software, a 3rd party library was
used to provide Attitude and Heading estemates from the measured data. The
library used is a fork of `RTIMULib2 <https://github.com/torejohansson97/RTIMULib2/tree/d128aec0bbbaf7efa5177c2604f7253340a0813d>`_ that is included in one of the
submodules of this repository. The library can provide estimates using either a
Kalman-Filter or RTQF. Since the library did not include any drivers for the
sensors on BerryGPS-IMU, they where developed by us. To connect the IMU to the
ROS network a bare-bone ROS publisher where written based on `this <https://wiki.ros.org/ROS/Tutorials/WritingPublisherSubscriber%28c%2B%2B%29>`_ guide.


Usage
======================
Xsens MTI-3 AHRS
---------------------
To use the Xsens MTI-3 AHRS in condjunction with ROS you need:
	* Xsens MTI-3 SoM assembled to the carrier PCB
	* Raspberry Pi with ROS Nuetic installed and fully setup
	* The Xsens MT SDK downloaded to the Raspberry Pi and installed
	  accourding to `this <http://wiki.ros.org/xsens_mti_driver>`_ guide

Connect the carrier PCB to the Raspberry Pi with a USB cable. Select power
option with JP1. Navigate to catkin_ws/src and run the following commands 
to source the workspace and launch the ROS node

.. code-block:: bash

	source devel/setup.bash
	roslaunch xsens_mti_driver xsens_mti_node.launch

The ROS node shuld launch and connect to an avalible ROS master or launch a
local master if no other is found. If everything works as intended you shuld see

.. code-block:: bash

	Measuring...

In your terminal window. If not, then refer to the troubelshoting on Xsens
`webpage. <http://wiki.ros.org/xsens_mti_driver>`_

BerryGPS-IMU v4
--------------------
.. warning::
        In the current version of the software, data from the magnetometer is not
        accurate and causes the attitude to be wrong. Presumably this is due to the
        callibration not working. A workaround is to disabel magnetic data in the
        estimation.

To use the BerryGPS-IMU v4 in conjunction with ROS you need:
	* BerryGPS-IMU v4
	* Raspberry Pi with ROS Nuetic installed and fully setup
	* `RTIMULib2 Fork <>`_ including BerryGPS-IMU drivers
	* `ROS Publisher <>`_ for the BerryGPS-IMU v4

You can use `this <https://github.com/torejohansson97/tightly-coupled-gnss-data-logger_BerryIMU/tree/368e0a21c8dc84bf8f7905a99adabbd537f0ffea>`_ repository to get all the necessary software listed above.

Initial setup
^^^^^^^^^^^^^^
Clone the above repository to you local ROS workspace by issiung the following
commands:

.. code-block:: bash

	cd catkin_ws
	git clone URL ./src
	cd src
	git submodule init
	git submodule update

Follow by building your catkin workspace:

.. code-block:: bash

	cd ~/catkin_ws
	catkin_make

Also make sure to build and install the RTIMULib which includes the hardware
drivers and sensor fusion algorithms:

.. code-block:: bash

	cd ~/catkin_ws/src/RTIMULib2/Linux
	mkdir build
	cd build
	cmake ..
	make -j4
	make install
	ldcofig

Copy the RTIMUConfig file to your catkin workspace

.. code-block:: bash

	cp ~/catkin_ws/src/BerryIMU/RTIMULib.ini ~/catkin_ws/

Run the ROS node by sourcing your workspace and then launching the node:

.. code-block:: bash

	source devel/setup.bash
	rosrun BerryIMU BerryIMU_node

If the node finds a ROS master it will launch and you will see

.. code-block:: bash

	Measuring...

In your terminal. If not, contact the software maintainer.

