GNSS_TMUX_SESSION="gnss_sdr"
ROSBAG_FOLDER="/home/$(whoami)/rosbags"

IMU_USER="nss"
IMU_IP="192.168.0.4"
IMU_PASSWORD="123456"

CANBUS_USER="nss"
CANBUS_IP="192.168.0.3"
CANBUS_PASSWORD="123456"

ROS_MASTER_IP="192.168.0.1"
ROS_MASTER_PORT="11311"

VIRTUAL_CAN_PATH="/home/nss/catkin_ws/src/can2piros/vcan_setup.sh"

# Open TMUX session and open appropriate windows
tmux -2 new-session -d -s $GNSS_TMUX_SESSION -n "ros-core"
tmux new-window -t $GNSS_TMUX_SESSION:1 -n 'ros-bridge'
tmux new-window -t $GNSS_TMUX_SESSION:2 -n 'sdr'
tmux new-window -t $GNSS_TMUX_SESSION:3 -n 'node-synchro'
tmux new-window -t $GNSS_TMUX_SESSION:4 -n 'node-pvt'
tmux new-window -t $GNSS_TMUX_SESSION:5 -n 'node-imu'
tmux new-window -t $GNSS_TMUX_SESSION:6 -n 'node-canbus-1'
tmux new-window -t $GNSS_TMUX_SESSION:7 -n 'node-canbus-2'
tmux new-window -t $GNSS_TMUX_SESSION:8 -n 'rosbag'
tmux new-window -t $GNSS_TMUX_SESSION:9 -n 'control'

# Start roscore in first pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:0
# Source ROS1
tmux send-keys "source /opt/ros/noetic/setup.bash" C-m
# Start roscore
tmux send-keys "roscore" C-m


# Start ROS1-ROS2 bridge in second pane
tmux select-window -t $GNSS_TMUX_SESSION:1
tmux send-keys "source ~/bridge_ws/install/setup.bash" C-m
tmux send-keys "ros2 run ros1_bridge dynamic_bridge --bridge-all-topics" C-m


# Start gnss-sdr in third pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:2
# Start playback (TODO: change to GNSS-SDR)
# tmux send-keys "gnss-sdr --config_file=/home/odroid/gnss-sdr/config/gnss-sdr_playback.conf" C-m
tmux send-keys "cd ~/gnss-sdr/work" C-m
tmux send-keys "./repeat_playback.sh" C-m

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

# Start node-imu in sixth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:5
# SSH into pi IMU using tmux sshpass to pass password
tmux send-keys "sshpass -p $IMU_PASSWORD ssh $IMU_USER@$IMU_IP" C-m
# Send password
tmux send-keys "$IMU_PASSWORD" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Start node-imu
tmux send-keys "roslaunch xsens_mti_driver display.launch" C-m

# Start node-canbus in seventh pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:6
# SSH into pi CANBUS using sshpass to pass password
tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_IP" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Run virtual canbus setup script
tmux send-keys "echo $CANBUS_PASSWORD | sudo -S bash $VIRTUAL_CAN_PATH" C-m
# Start node-canbus
tmux send-keys "rosrun obd2bridge fake_car_node.py vcan0" C-m

# Start node-canbus in eighth pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:7
# SSH into pi CANBUS using sshpass to pass password
tmux send-keys "sshpass -p $CANBUS_PASSWORD ssh $CANBUS_USER@$CANBUS_IP" C-m
# Source ROS1_ws
tmux send-keys "source ~/catkin_ws/devel/setup.bash" C-m
# Export ROS_MASTER_URI
tmux send-keys "export ROS_MASTER_URI=http://$ROS_MASTER_IP:$ROS_MASTER_PORT/" C-m
# Start node-canbus
tmux send-keys "rosrun obd2bridge odb_decode_node.py vcan0" C-m

# Start ros2 bag in eight pane
# Select pane
tmux select-window -t $GNSS_TMUX_SESSION:8
# Source ROS2_ws
tmux send-keys "source ~/ros2_ws/install/setup.bash" C-m
# Start ros2 bag to record everything in folder ~/rosbags
tmux send-keys "ros2 bag record -a -o $ROSBAG_FOLDER" C-m


# End of script ===============================================================
# Set default window (control)
tmux select-window -t $GNSS_TMUX_SESSION:9
# Attach to session
tmux -2 attach-session -t $GNSS_TMUX_SESSION
# =============================================================================


