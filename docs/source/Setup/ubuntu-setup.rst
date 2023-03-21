Ubuntu Setup 
===============

.. contents:: Table of Contents
   :depth: 1
   :local:

Network Setup
------------------
Some devices in the data logger is communication with the Central computer using
a switched Ethernet network. All devices in the network have been assigned a
static IP address. On modern Ubuntu this is achieved by modifying the file /etc/netplan.
An example configuration is shown here:

This will assign the static IP 123.456.78.9 and also leave DHCP enabled. This
allows the devices to also connect to another network (i.e the internet) if
needed.

On the central computer further configuration has been done to enable WiFi
sharing, and the firewall have been configured to pass traffic between the WiFi
interface and the static network configured on the NUC. This enables the user to
connect to the data logger wirelessly by connecting to the "GNSS-datalogger"
network. To enable WiFi sharing on boot, open the file
/etc/NetworkManager/system-connection/Hotspot and find the line

.. code-block:: bash

	autoconnect=false

and change it to true.
To configure the firewall for to pass traffic between this network and the local
static (IP Forwarding) execute the following commands:
Edit the /etc/sysctl.conf file from

.. code-block:: bash

	net.ipv4.ip_forward = 0

to

.. code-block:: bash

	net.ipv4.ip_forward = 1

Then configure the firewall (NAT):
Install iptables-persistent package to make changes persistent after boot

.. code-block:: bash

	apt install iptables-persistent

Configure your iptables

.. code-block:: bash

	iptables -A FORWARD -j ACCEPT
	iptables -t nat -s 123.456.0/24 -A POSTROUTING -j MASQUERADE

.. note::
        Change the IP address to be the what you have selected for you static network.

.. warning::
        This exact procedure have not been tested and might need adjustment or futher
        steps.
        `Source. <https://www.linode.com/docs/guides/linux-router-and-ip-forwarding/>`_

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


