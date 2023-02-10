#!/bin/bash

CANBUS_USER="nss"
CANBUS_HOSTNAME="obd-pi"
CANBUS_PASSWORD="123456"

# Get flags
while getopts 'so:' OPTION; do
    case "$OPTION" in
        s)
            echo "Logging into the obd-pi and getting the GPIO state..."
            STATE=$(sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME 'gpio -g read 14')
            echo "The state of the GPIO is $STATE"
            exit
        ;;
        o)
            # Get the state from the flag
            STATE="$OPTARG"
            # Check if STATE is 1 or true
            if [ $STATE == "1" ] || [ $STATE == "true" ]; then
                # If we ever use ROS, this needs to be changed to "true" (not 1) 
                # and the else statement to "false" (not 0)
                STATE="1"
            else
                STATE="0"
            fi

            echo "Logging into the obd-pi and setting pin state..."

            OUTPUT=$(sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME "
            echo 'Exporting the GPIOs...'
            # Export the GPIO using the BCM numbering (no -g for the export command, it's enabled by default)
            # Attacker switch (BCM 14)
            echo $CANBUS_PASSWORD | sudo -kS gpio export 14 out
            # Confirmation red LED (BCM 22)
            echo $CANBUS_PASSWORD | sudo -kS gpio export 22 out
            echo 'Setting the GPIOs to $STATE...'
            # IMPORTANT: DO NOT CALL WITH -g FLAG SUDO OR IT WILL NOT WORK
            gpio -g write 14 $STATE
            gpio -g write 22 $STATE")

            echo -e "\n\nThe output of the command was: \n$OUTPUT"
            exit
        ;;
        ?)
            echo "script usage: $(basename \$0) [-s] (get status of GPIO) [-o boolean] (set state of GPIO)" >&2
            exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"
