
#!/usr/bin/env python
import sys
import rospy
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Quaternion
import tf

odom_topic = sys.argv[1]

def callback(odom):
    br = tf.TransformBroadcaster()
    br.sendTransform((odom.pose.pose.position.x, odom.pose.pose.position.y, 0),
                     (odom.pose.pose.orientation.x, odom.pose.pose.orientation.y, odom.pose.pose.orientation.z, odom.pose.pose.orientation.w),
                     rospy.Time.now(),
                     "base_link",
                     "odom")

def listener():
    rospy.init_node('odom_transform_publisher')
    rospy.Subscriber(odom_topic, Odometry, callback)
    rospy.spin()

if __name__ == '__main__':
    listener()