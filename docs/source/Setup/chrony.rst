Chrony
===============

.. contents:: Table of Contents
   :depth: 1
   :local:

Installation
-------------

To install Chrony on your system, you need to run the following command:

.. code-block:: bash

    sudo apt install chrony


After installation you will need to either reboot the computer or run the following command:

.. code-block:: bash

    systemctl start chronyd

This will initialize some configuration file that need to be modified.

Now in order for the deamon to start automatically at boot, the following command needs to be run:

.. code-block:: bash

    systemctl enable chronyd

Configuration steps
-------------

Central computer
^^^^^^^^^^^^^^^^^^^^^^
If the computer on which you are installing Chrony is the central computer, do the following:

1. Open the configuration file with the following command:

.. code-block:: bash

    sudo nano /etc/chrony/chrony.conf

2. Replace the content of the file with the following:

.. code-block:: bash

    initstepslew 1 LIST_OF_REMOTE_HOSTNAMES_CONNECTED_TO_THIS_COMPUTER
    driftfile /var/lib/chrony/drift
    local stratum 8
    manual
    allow 123.456.789.0/24
    smoothtime 400 0.01
    rtcsync

.. note::
    Replace 123.456.789.0 with the IP subnet used for communication.
    The 0 indicates that all IP of the form 123.456.789.XXX are allowed.

Remote node computer
^^^^^^^^^^^^^^^^^^^^^^

If the computer on which you are installing Chrony is a remote node, do this instead

1. Open the configuration file with the following command:

.. code-block:: bash

    sudo nano /etc/chrony/chrony.conf

2. Replace the content of the file with the following:

.. code-block:: bash

    server HOSTNAME_OF_CENTRAL_COMPUTER iburst
    driftfile /var/lib/chrony/drift
    allow 123.456.789.0/24
    makestep 1.0 3
    rtcsync

.. note::
    Replace 123.456.789.0 with the IP subnet used for communication.
    The 0 indicates that all IP of the form 123.456.789.XXX are allowed.
