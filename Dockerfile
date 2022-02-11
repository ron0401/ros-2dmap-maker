FROM ros:melodic-ros-base
LABEL Name=ros-2dmap-maker Version=0.0.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-gmapping \
    ros-melodic-tf \
    ros-melodic-tf2 \
    ros-melodic-map-server \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# # Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

COPY start.sh /tmp/start.sh
COPY odom_tf_publisher.py /tmp/odom_tf_publisher.py
COPY rosbag.bag /tmp/rosbag/rosbag.bag

RUN chmod +x /tmp/start.sh
RUN chmod +x /tmp/odom_tf_publisher.py

USER $USERNAME
RUN mkdir -p /home/$USERNAME/map
ENV TF_SCAN_FRAME=base_scan
ENV TF_BASELINK_TO_SCAN="0 0 0 0 0 0"
ENV TOPIC_SCAN=/scan
ENV TOPIC_ODOM=/odom
ENV BAG_PLAY_SPEED=1
ENV BAG_FILE_NAME=rosbag.bag

WORKDIR /home/$USERNAME

CMD ["bash", "-c", "/tmp/start.sh"]
