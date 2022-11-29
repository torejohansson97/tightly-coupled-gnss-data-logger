GNSS_TMUX_SESSION="gnss_sdr"

# Open TMUX session and open appropriate windows
tmux -2 new-session -d -s $GNSS_TMUX_SESSION -n "ros-core"
tmux new-window -t $GNSS_TMUX_SESSION:1 -n 'ros-bridge'
tmux new-window -t $GNSS_TMUX_SESSION:2 -n 'sdr'
tmux new-window -t $GNSS_TMUX_SESSION:3 -n 'node-synchro'
tmux new-window -t $GNSS_TMUX_SESSION:4 -n 'node-pvt'

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



# End of script ===============================================================
# Set default window (ros1)
tmux select-window -t $GNSS_TMUX_SESSION:1
# Attach to session
tmux -2 attach-session -t $GNSS_TMUX_SESSION
# =============================================================================


