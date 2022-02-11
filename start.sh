#!/bin/bash
source /opt/ros/melodic/setup.bash
roscore &
sleep 1
rosparam set use_sim_time true
sleep 1
rosrun tf static_transform_publisher ${TF_BASELINK_TO_SCAN} base_link ${TF_SCAN_FRAME} 100 &
rosrun gmapping slam_gmapping &
python /tmp/odom_tf_publisher.py odom &
rosbag play /tmp/rosbag/$BAG_FILE_NAME ${TOPIC_SCAN}:=/scan ${TOPIC_ODOM}:=/odom --clock -r ${BAG_PLAY_SPEED}

cd /home/ubuntu/map
rosrun map_server map_saver -f map