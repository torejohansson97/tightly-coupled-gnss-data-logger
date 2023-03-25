Logging
===============

.. contents:: Table of Contents
   :depth: 1

The following list of commands are all aliases located in the ~/.bashrc file. They are used to start and stop logging sessions.

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

.. code-block:: bash

   set-attacker off

Turn off the attacker.

.. code-block:: bash

   set-attacker on

Turn on the attacker.