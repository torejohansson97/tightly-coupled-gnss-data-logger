Logging
===============

.. contents:: Table of Contents
   :depth: 1

The following list of commands are all aliases located in the ~/.bashrc file. They are used to start and stop logging sessions.

.. note::
   :class: warning

   In order for any of the above commands to work, the .bashrc file must be sourced and edited to include the correct paths to the logging scripts.
   You can find an example of the .bashrc over `here </src/scripts/add_bashrc>`_.

Start/Stop a logging session
----------------------------

.. code-block:: bash

   start-logging [-v][-r]

Start a logging session.
The -v flag will start a logging session with a virtual CAN interface.
The -r flag will start a logging session wtih a replay file for the GNSS-SDR module.

.. code-block:: bash

   stop-logging


Set the attacker on/off
-----------------------

Turn off the attacker.

.. code-block:: bash

   attacker-off


Turn on the attacker.

.. code-block:: bash

   attacker-on


Read the state of the attacker

.. code-block:: bash

   attacker-state
