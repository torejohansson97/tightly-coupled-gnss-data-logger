GNSS_TMUX_SESSION="the_eye_of_sauron"
# Send a SIGINT to the recoring tmux pane
tmux send-keys -t $GNSS_TMUX_SESSION:11 C-c

# Find most recently created directory
LATEST_ROSBAG_DIR=$(ls -td ~/rosbags/*/ | head -1)
# Wait for metadat.yaml to be present in the directory
while [ ! -f $LATEST_ROSBAG_DIR/metadata.yaml ]; do
    sleep 1
done

tmux kill-session -t $GNSS_TMUX_SESSION