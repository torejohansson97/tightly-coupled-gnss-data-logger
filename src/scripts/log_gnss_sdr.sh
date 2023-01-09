GNSS_TMUX_SESSION="the_eye_of_sauron"

ROSBAG_FOLDER="/home/$(whoami)/rosbags"
NOW="$(date +"%Y-%m-%d_%Hh%Mm")"
ROSBAG_NAME="recording_$NOW"
ROSBAG_PATH="$ROSBAG_FOLDER/$ROSBAG_NAME"

IMU_USER="nss"
BERRY_IMU_HOSTNAME="berry-pi"
XSENS_IMU_HOSTNAME="xsens-pi"
IMU_PASSWORD="123456"

CANBUS_USER="nss"
CANBUS_HOSTNAME="obd-pi"
CANBUS_PASSWORD="123456"

ROS_MASTER_IP="192.168.0.1"
ROS_MASTER_PORT="11311"

# Command line flag to pick between virtual and real CAN bus
# 0: Virtual CAN bus
# 1: Real CAN bus
CANBUS="can0"
GNSS_SDR_SCRIPT_NAME="gnss_sdr_realtime.sh"
while getopts 'vr' OPTION; do
  case "$OPTION" in
    v)
      echo "USING VCAN0"
      CANBUS="vcan0"
      ;;
    r)
      echo "Starting with replay GNSS-SDR"
      GNSS_SDR_SCRIPT_NAME="gnss_sdr_playback.sh"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-v] (virtual canbus) [-r] (gnss-sdr replay)" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [ $CANBUS == "vcan0" ]; then
  echo "Starting with virtual CAN bus"
  CANBUS_SETUP_PATH="/home/nss/catkin_ws/src/can2piros/vcan_setup.sh"
else
  echo "Starting with real CAN bus"
  CANBUS_SETUP_PATH="/home/nss/catkin_ws/src/can2piros/can_setup.sh"
fi

# Open TMUX session and open appropriate windows
tmux -2 new-session -d -s $GNSS_TMUX_SESSION -n "ros-core"
tmux new-window -t $GNSS_TMUX_SESSION:1 -n 'ros-bridge'
tmux new-window -t $GNSS_TMUX_SESSION:2 -n 'sdr'
tmux new-window -t $GNSS_TMUX_SESSION:3 -n 'node-synchro'
tmux new-window -t $GNSS_TMUX_SESSION:4 -n 'node-pvt'
tmux new-window -t $GNSS_TMUX_SESSION:5 -n 'node-ublox'
tmux new-window -t $GNSS_TMUX_SESSION:6 -n 'node-xsens-imu'
tmux new-window -t $GNSS_TMUX_SESSION:7 -n 'node-berry-imu'
tmux new-window -t $GNSS_TMUX_SESSION:8 -n 'node-canbus-1'
tmux new-window -t $GNSS_TMUX_SESSION:9 -n 'node-canbus-2'
tmux new-window -t $GNSS_TMUX_SESSION:10 -n 'node-gpio'
tmux new-window -t $GNSS_TMUX_SESSION:11 -n 'rosbag'
tmux new-window -t $GNSS_TMUX_SESSION:12 -n 'control'

# Start roscore in first pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:0
# Source ROS1
tmux send-keys "source /opt/ros/noetic/setup.bash" C-m
# Start roscore
tmux send-keys "roscore" C-m

sleep 1

# Start ROS1-ROS2 bridge in second pane
tmux select-window -t $GNSS_TMUX_SESSION:1
tmux send-keys "source ~/bridge_ws/install/setup.bash" C-m
tmux send-keys "ros2 run ros1_bridge dynamic_bridge --bridge-all-topics" C-m

sleep 1

# Start gnss-sdr in third pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:2
tmux send-keys "cd ~/gnss-sdr/work" C-m
tmux send-keys "./$GNSS_SDR_SCRIPT_NAME" C-m

# Start node-synchro in fourth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:3
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Start node-synchro
tmux send-keys "cd ~/catkin_ws/src/gnss-sdr-ros/src" C-m
tmux send-keys "python3 gnss_synchro_udp.py" C-m


# Start node-pvt in fifth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:4
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Start node-pvt
tmux send-keys "cd ~/catkin_ws/src/gnss-sdr-ros/src" C-m
tmux send-keys "python3 gnss_pvt_udp.py" C-m

# Start node-ublox in fifth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:5
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Start node-ublox
tmux send-keys "roslaunch ublox_gps ublox_device.launch" C-m

# Start node-xsens-imu in sixth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:6
# SSH into pi IMU using tmux sshpass to pass password
tmux send-keys "sshpass -p $IMU_PASSWORD ssh $IMU_USER@$XSENS_IMU_HOSTNAME" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Start node-imu
tmux send-keys "roslaunch xsens_mti_driver display.launch" C-m

# Start node-berry-imu in seventh pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:7
# SSH into pi IMU using tmux sshpass to pass password
tmux send-keys "sshpass -p $IMU_PASSWORD ssh $IMU_USER@$BERRY_IMU_HOSTNAME" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Move to the catkin folder in order to detect the configuration file
tmux send-keys "cd ~/catkin_ws" C-m
# Start node-imu
tmux send-keys "rosrun BerryIMU BerryIMU_node" C-m

# Start node-canbus-1 in eighth pane (VIRTUAL CANBUS)
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:8
# SSH into pi CANBUS using sshpass to pass password
tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME" C-m
# If CANBUS is vcan0, start virtual canbus and the fake car node
if [ $CANBUS == "vcan0" ]
then
    echo "Starting virtual CANBUS..."
    # Source ROS1_ws
    tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
    # Export ROS_MASTER_URI
    tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
    # Run virtual canbus setup script
    tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS bash $CANBUS_SETUP_PATH" C-m
    # Start node-canbus
    tmux send-keys "rosrun obd2bridge fake_car_node.py $CANBUS" C-m
fi
# Run canbus setup script (virtual canbus (vcan0) or real canbus (can0) depending on the selected option)
tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS bash $CANBUS_SETUP_PATH" C-m

# Start node-canbus-2 in ninth pane (CANBUS LOGGING)
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:9
# SSH into obd-pi using sshpass to pass password
tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Start node-canbus
tmux send-keys "rosrun obd2bridge obd_decode_node.py $CANBUS" C-m

# Start node-gpio in tenth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:10
# SSH into obd-pi using sshpass to pass password
tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_HOSTNAME" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Kill pigpiod if it is already running
tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS killall pigpiod" C-m
# Run GPIO setup command
tmux send-keys "echo '$CANBUS_PASSWORD' | sudo -kS pigpiod" C-m
# Start node-gpio
tmux send-keys "rosrun gpio_control gpio_control_node --device pi --output 14" C-m

# Start ros2 bag in eleventh pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:11
# Source ROS2_ws
tmux send-keys "source ~/ros2_ws/install/setup.bash" C-m
# Start ros2 bag to record everything in folder ~/rosbags
tmux send-keys "ros2 bag record -a -o $ROSBAG_PATH" C-m


# End of script ===============================================================
# Set default window (control)
tmux select-window -t $GNSS_TMUX_SESSION:12
# Attach to session
tmux -2 attach-session -t $GNSS_TMUX_SESSION
# =============================================================================


