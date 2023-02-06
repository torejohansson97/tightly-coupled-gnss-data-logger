Ubuntu Setup 
===============

.. contents:: Table of Contents
   :depth: 1
   :local:


Ubuntu on Raspberry PI
-----------------------

The installation guide for ubuntu can be found here `ubuntu.com <https://ubuntu.com/download/raspberry-pi>`_
After installing ubuntu it needs some configuration such as configuring IP address and peripheral specific options, which is covered in the subsequent sections.

PICAN3 Configuration
---------------------
The drivers required are present in the kernel already however, the device needs to be enabled.

To enable the driver on Ubuntu, the following configuration text is supposed to be put in /boot/firmware/usercfg.txt

.. code-block:: bash
   
   dtparam=spi=on
   dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25
   dtoverlay=spi-bcm2835-overlay


