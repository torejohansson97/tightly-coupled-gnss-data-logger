Chrony
===============

.. contents:: Table of Contents
   :depth: 2
   :local:

Installation
-------------

To install Chrony on your system, you need to run the following command:

.. code-block:: bash

    sudo apt install chrony

.. note::

    After installation you will need to either reboot the computer or run the following command:
    .. code-block:: bash

        systemctl start chronyd

    This will initialize some configuration file that need to be modified

Configuration steps
-------------

Central computer
^^^^^^^^^^^^^^^^^^^^^^
If the computer on which you are installing Chrony is the central computer, paste the following inside the file:

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

Remote node computer
^^^^^^^^^^^^^^^^^^^^^^

If the computer on which you are installing Chrony is a remote node, paste this instead

.. code-block:: bash

    server HOSTNAME_OF_CENTRAL_COMPUTER iburst
    driftfile /var/lib/chrony/drift
    allow 123.456.789.0/24
    makestep 1.0 3
    rtcsync

.. note::
    Replace 123.456.789.0 with the IP subnet used for communication.
    The 0 indicates all IP of the form 123.456.789.XXX