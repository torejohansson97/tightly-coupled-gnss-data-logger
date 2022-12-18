"""Example: Register types from msg files."""

from pathlib import Path
import dtale

from rosbags.typesys import get_types_from_msg, register_types, generate_msgdef



add_types = {}

for messages in [
    ('/home/master/catkin_ws/src/gnss-sdr-ros/msg/GNSSSynchro.msg', "gnss_sdr2/msg/GNSSSynchro"),
    ('/home/master/catkin_ws/src/gnss-sdr-ros/msg/Observables.msg', "gnss_sdr2/msg/Observables"),
    ('/home/master/catkin_ws/src/gnss-sdr-ros/msg/MonitorPvt.msg', "gnss_sdr2/msg/MonitorPvt"),
]:
    pathstr = messages[0]
    msg_type = messages[1]
    msgpath = Path(pathstr)
    msgdef = msgpath.read_text(encoding='utf-8')
    add_types.update(get_types_from_msg(msgdef, msg_type))

register_types(add_types)

# Type import works only after the register_types call,
# the classname is derived from the msgtype names above.

# pylint: disable=no-name-in-module,wrong-import-position
from rosbags.typesys.types import gnss_sdr2__msg__GNSSSynchro as GNSSSynchro  # type: ignore  # noqa
from rosbags.typesys.types import gnss_sdr2__msg__Observables as Observables  # type: ignore  # noqa
from rosbags.typesys.types import gnss_sdr2__msg__MonitorPvt as MonitorPvt  # type: ignore  # noqa

"""Example: Read messages from rosbag."""

from rosbags.rosbag2 import Reader as ROS2Reader
from rosbags.dataframe import get_dataframe
from rosbags.highlevel import AnyReader
import sqlite3

from rosbags.serde import deserialize_cdr
import matplotlib.pyplot as plt
import os
import collections
import argparse
import pandas as pd
        
parser = argparse.ArgumentParser(description='Extract images from rosbag.')
# input will be the folder containing the .db3 and metadata.yml file
parser.add_argument('--input','-i',type=str, help='rosbag input location')
# run with python filename.py -i rosbag_dir/

# READ CUSTOM MESSAGE WITH ROSBAG2
# https://stackoverflow.com/questions/73420147/how-to-read-custom-message-type-using-ros2bag
# https://ternaris.gitlab.io/rosbags/examples/register_types.html

args = parser.parse_args()

rosbag_dir = args.input

# topic = "/topic/name"
frame_counter = 0


def get_msg_keys(msg_type):
    print(type(msg_type))

import re
from time import sleep
message_fields = []
def dfs(msg, type_name, branch=0,prefix=""):
    """ Depth-first search of a message type. """
    type_string = repr(type(msg)).split("'")[1].removeprefix("'").removesuffix("'")
    # print(type_string)
    if not type_string.startswith('rosbags'):
        message_fields.append(type_name)
        # print(f"RETURN : {branch}, {type_name}")
        # sleep(0.1)
        return
    for field in dir(msg):
        if not field.startswith('__'):
            if len(type_name) == 0:
                new_string = f"{field}" if prefix == "" else f"{prefix}.{field}"
            else:
                new_string = type_name + f".{field}"
            dfs(getattr(msg, field), new_string, branch+1)

def get_attribute(obj, path_string):
    parts = path_string.split('.')
    final_attribute_index = len(parts)-1
    current_attribute = obj
    i = 0
    for part in parts:
        new_attr = getattr(current_attribute, part, None)
        if current_attribute is None:
            print('Error %s not found in %s' % (part, current_attribute))
            return None
        if i == final_attribute_index:
            return getattr(current_attribute, part)
        current_attribute = new_attr
        i += 1



# Get topic names
topics = []
exlcude_topics = ["/rosout", "/rosout_agg","/parameter_events"]
message_types = {}
with AnyReader([Path(rosbag_dir)]) as reader:
    for connection in reader.connections:
        print(f"TOPIC : {connection.topic:30} \t MSG_TYPE : {connection.msgtype}")
        if connection.topic not in exlcude_topics:
            topics.append(connection.topic)
        
    # iterate over messages
    for connection, timestamp, rawdata in reader.messages():

        if connection.topic == "/gnss/syncrho" and connection.topic not in message_types:
            msg = deserialize_cdr(rawdata, connection.msgtype)
            dfs(msg.observable[0],"")
            message_types[connection.topic] = message_fields
            message_fields=[]
            dfs(msg,"",prefix="")
            message_types[connection.topic].extend(message_fields)
            message_fields=[]
        # check if topic in message_types
        elif connection.topic not in message_types and connection.topic not in exlcude_topics:
            msg = deserialize_cdr(rawdata, connection.msgtype)

            dfs(msg,"")
            message_types[connection.topic] = message_fields
            message_fields=[]


        # check if len message_types is equal to len topics
        if len(message_types) == len(topics):
            break

print(f"message_types : {message_types}")
print(f"topics : {topics}")

dataframe_dict = {}
with AnyReader([Path(rosbag_dir)]) as reader:
    for topic in topics:
        if topic != "/gnss/syncrho":
            print(topic)
            try:
                dataframe_dict[topic] = get_dataframe(reader, topic, message_types[topic])
                print(dataframe_dict[topic])
            except:
                # Remove that topic from the list
                print(f"WARNING : {topic} has no messages")
                topics.remove(topic)
                continue

# How to access header
with AnyReader([Path(rosbag_dir)]) as reader:
    dataframe_dict["/gnss/syncrho"] = get_dataframe(reader, '/gnss/syncrho', ['observable'])

    # iterate though each row and add a column for each field in the message
    for index, row in dataframe_dict["/gnss/syncrho"].iterrows():
        for i in range(0,len(row['observable'])):
            for field in message_types['/gnss/syncrho']:
                if field != "observable":
                    dataframe_dict["/gnss/syncrho"].at[index,f"observable.{i}.{field}"] = get_attribute(row['observable'][i], field)


    # unpack column into multiple columns
    # dataframe = dataframe.explode('observable')
    # dataframe = dataframe["observable"].apply(lambda x: pd.Series([get_attribute(x, field) for field in message_types['/gnss/syncrho'] if field != "observable"]))
    print(dataframe_dict["/gnss/syncrho"]["observable.0.signal"])


print(dataframe_dict)
# Merge all pandas dataframes into one column-wise
dataframe = pd.concat(dataframe_dict, axis=1)
d = dtale.show(dataframe, subprocess=False)