GPIO_SETTER="gpio-setter"

CANBUS_USER="nss"
CANBUS_HOSTNAME="obd-pi"
CANBUS_PASSWORD="123456"

# Needed if we use ROS messages
# source ~/catkin_ws/devel/setup.bash

tmux -2 new-session -d -s $GPIO_SETTER -n 'sneaky-gpio-setter'
tmux select-window -t $GPIO_SETTER:0
# Get flags
while getopts 'so:' OPTION; do
    case "$OPTION" in
        s)
            echo "Logging into the obd-pi..."
            tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME" C-m
            echo "Getting the GPIO state..."
            # Get the state from the file using the BCM numbering
            tmux send-keys "STATE=$(gpio -g read 14)" C-m
            # Get the STATE variable from the tmux environment variables back into our shell
            STATE=$(tmux show-environment -g | grep STATE | cut -d '=' -f 2)
            # Print the state
            echo "The state of the GPIO is $STATE"
            exit
        ;;
        o)
            echo "Logging into the obd-pi..."
            tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME"
            # Export the GPIO using the BCM numbering (no -g for the export command, it's enabled by default)
            echo "Exporting the GPIOs..."
            tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS gpio export 14 out" C-m
            tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS gpio export 22 out" C-m

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

            tmux send-keys "echo 'Setting the GPIO to $STATE'" C-m
            # Set the state of the GPIO
            tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS gpio -g write 14 $STATE" C-m
            # Confirmation red LED
            tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS gpio -g write 22 $STATE" C-m
            # This is the ROS command to set the state of the GPIO
            # rostopic pub -1 /gpio_outputs/fourteen gpio_control/OutputState "state: $STATE"
            exit
        ;;
        ?)
            echo "script usage: $(basename \$0) [-s] (get status of GPIO) [-o boolean] (set state of GPIO)" >&2
            exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"
