"""Example: Register types from msg files."""

from pathlib import Path
import argparse
import pandas as pd
import tkinter as tk
import re


from rosbags.typesys import get_types_from_msg, register_types


parser = argparse.ArgumentParser(description='Extract images from rosbag.')
# input will be the folder containing the .db3 and metadata.yml file
parser.add_argument('--input','-i',type=str, help='rosbag input location')
parser.add_argument('--msg_path', '-m', type=str, help='path to root msg folder')
parser.add_argument('--output','-o',type=str, help='CSV output location')
parser.add_argument('--interpolate', '-n', action="store_true", help='interpolate missing values')
args = parser.parse_args()



add_types = {}

message_dir = Path(args.msg_path)
# Get all .msg file in the msg directory using listdir
msg_list = result = list(Path(message_dir).rglob("*.[mM][sS][gG]"))

print(msg_list)

for message_path in msg_list:
    msgdef = message_path.read_text(encoding='utf-8')
    # Extract msg type from file name and path (e.g. gnss_sdr2/msg/GNSSSynchro.msg)
    path_parts = str(message_path).split("/")
    msg_type = "/".join(path_parts[-3:]).removesuffix(".msg")
    print(msg_type)
    add_types.update(get_types_from_msg(msgdef, msg_type))

register_types(add_types)

# Type import works only after the register_types call,
# the classname is derived from the msgtype names above.

# pylint: disable=no-name-in-module,wrong-import-position
# from rosbags.typesys.types import gnss_sdr2__msg__GNSSSynchro as GNSSSynchro  # type: ignore  # noqa
# from rosbags.typesys.types import gnss_sdr2__msg__Observables as Observables  # type: ignore  # noqa
# from rosbags.typesys.types import gnss_sdr2__msg__MonitorPvt as MonitorPvt  # type: ignore  # noqa

from rosbags.typesys.types import *

"""Example: Read messages from rosbag."""

from rosbags.dataframe import get_dataframe
from rosbags.highlevel import AnyReader

from rosbags.serde import deserialize_cdr
        
# run with python filename.py -i rosbag_dir/

# READ CUSTOM MESSAGE WITH ROSBAG2
# https://stackoverflow.com/questions/73420147/how-to-read-custom-message-type-using-ros2bag
# https://ternaris.gitlab.io/rosbags/examples/register_types.html

rosbag_dir = args.input

def get_msg_keys(msg_type):
    print(type(msg_type))

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
exclude_topics = ["/rosout", "/rosout_agg","/parameter_events"]
message_types = {}
with AnyReader([Path(rosbag_dir)]) as reader:
    for connection in reader.connections:
        print(f"TOPIC : {connection.topic:30} \t MSG_TYPE : {connection.msgtype}")
        if connection.topic not in exclude_topics:
            topics.append(connection.topic)
        
    # iterate over messages
    for connection, timestamp, rawdata in reader.messages():
        # Check if message type as already been seen and dealt with
        if connection.topic not in message_types and connection.topic not in exclude_topics:
            # Check all fields of object and check if they are lists or not
            # if so, run dfs on them
            msg = deserialize_cdr(rawdata, connection.msgtype)
            # Grab all fields of the message
            dfs(msg,"",prefix="")
            # Check for lists
            for field in message_fields.copy():
                if isinstance(get_attribute(msg,field), list):
                    for i in range(len(get_attribute(msg,field))):
                        dfs(get_attribute(msg,field)[i],f"{field}.{i}",prefix="")
                    # Remove the field from message_fields
                    message_fields.remove(field)
            # Save those fields to message_types
            message_types[connection.topic] = message_fields
            message_fields=[]
        # if connection.topic == "/gnss/syncrho" and connection.topic not in message_types:
        #     msg = deserialize_cdr(rawdata, connection.msgtype)
        #     dfs(msg.observable[0],"")
        #     message_types[connection.topic] = message_fields
        #     message_fields=[]
        #     dfs(msg,"",prefix="")
        #     message_types[connection.topic].extend(message_fields)
        #     message_fields=[]
        # # check if topic in message_types
        # elif connection.topic not in message_types and connection.topic not in exlcude_topics:
        #     msg = deserialize_cdr(rawdata, connection.msgtype)

        #     dfs(msg,"")
        #     message_types[connection.topic] = message_fields
        #     message_fields=[]


        # check if len message_types is equal to len topics
        if len(message_types) == len(topics):
            break

# Clean the message_types by removing any value from the list that contain a capital letter
for topic in message_types:
    message_types[topic] = [x for x in message_types[topic] if not any(c.isupper() for c in x)]


class FieldItem():
    def __init__(self, field_name, topic):
        self.field_name = field_name
        self.topic = topic

    def __repr__(self):
        return f"{self.field_name} : {self.topic}"

    def __str__(self) -> str:
        return f"{self.field_name}"

class EntryWithPlaceholder(tk.Entry):
    def __init__(self, master=None, placeholder="PLACEHOLDER", color='grey'):
        super().__init__(master)

        self.placeholder = placeholder
        self.placeholder_color = color
        self.default_fg_color = self['fg']

        self.bind("<FocusIn>", self.foc_in)
        self.bind("<FocusOut>", self.foc_out)

        self.put_placeholder()

    def put_placeholder(self):
        self.insert(0, self.placeholder)
        self['fg'] = self.placeholder_color

    def foc_in(self, *args):
        if self['fg'] == self.placeholder_color:
            self.delete('0', 'end')
            self['fg'] = self.default_fg_color

    def foc_out(self, *args):
        if not self.get():
            self.put_placeholder()

# merge all values from message_types into a single list with value that look like "key/value"
fields = [FieldItem(f"{key}/{value}", key) for key in message_types for value in message_types[key]]
fields = sorted(fields, key=lambda x: x.field_name)

# Create a list for the selected fields (used later)
selected_fields = []

# Create the main window
window = tk.Tk()
window.title("Field Selector")
window.geometry("1000x600")

# Create the left frame with a list of fields
left_frame = tk.Frame(window)
left_frame.pack(side='left', fill='both', expand=True)
scrollbar = tk.Scrollbar(left_frame)
scrollbar.pack(side='right', fill='y')
fields_list = tk.Listbox(left_frame, width=20, selectmode='extended', yscrollcommand=scrollbar.set)
for field_item in fields:
    fields_list.insert('end', field_item)

print(fields_list.get(0, 'end'))
fields_list.pack(side='left', fill='both', expand=True)
scrollbar.config(command=fields_list.yview)

# Create the right frame with a list of selected fields and a plus button
right_frame = tk.Frame(window)
right_frame.pack(side='right', fill='both', expand=True)
selected_scrollbar = tk.Scrollbar(right_frame)
selected_scrollbar.pack(side='right', fill='y')
selected_fields_list = tk.Listbox(right_frame, width=20, selectmode='extended', yscrollcommand=selected_scrollbar.set)
selected_fields_list.pack(side='left', fill='both', expand=True)
selected_scrollbar.config(command=selected_fields_list.yview)

# Button to add and remove fields
add_button = tk.Button(right_frame, text='+', command=lambda: add_fields())
add_button.pack()
remove_button = tk.Button(right_frame, text='-', command=lambda: remove_topics())
remove_button.pack()
# Button to close the window
close_button = tk.Button(right_frame, text='Extract fields', command=lambda: extract_fields())
close_button.pack()

def extract_fields():
    global selected_fields
    selected_fields = selected_fields_list.get(0, 'end')
    selected_fields = [str(field) for field in selected_fields]
    window.destroy()

# Create the search bar and bind it to the search function
search_frame = tk.Frame(window)
search_bar = EntryWithPlaceholder(search_frame, placeholder="Search topics...")
search_bar.pack()
search_bar.bind('<KeyRelease>', lambda event: search())

# Add a function to add the selected fields to the list of selected fields
def add_fields():
    selected_indices = fields_list.curselection()
    for index in selected_indices:
        selected_field = fields_list.get(index)
        if selected_field not in selected_fields_list.get(0, 'end'):
            selected_fields_list.insert('end', selected_field)

# Add a function to remove the selected topics from the list of selected topics
def remove_topics():
    selected_indices = selected_fields_list.curselection()
    for index in reversed(selected_indices):
        selected_fields_list.delete(index)

# Add a function to search the list of fields and filter the displayed items
def search():
    search_term = search_bar.get().lower()
    fields_list.delete(0, 'end')
    for field_item in fields:
        if search_term in field_item.field_name.lower():
            fields_list.insert('end', field_item)

# Pack the frames and start the main loop
left_frame.pack(side='left')
right_frame.pack(side='right')
search_frame.pack(side='top')
window.mainloop()

# Check if the list is empty
if len(selected_fields) == 0:
    print('No fields selected')
    quit()
# filter message_types to only contain the selected fields
filtered_message_types = {}
for field in fields:
    if field.field_name in selected_fields:
        if field.topic not in filtered_message_types:
            filtered_message_types[field.topic] = []
        filtered_message_types[field.topic].append(field.field_name.split('/')[-1])

print(filtered_message_types)

dataframe_dict = {}
things_to_remove = []
with AnyReader([Path(rosbag_dir)]) as reader:
    for topic, fields in filtered_message_types.items():
        print(topic)
        try:
            for field in fields:
                # This detects string of the form "text.NUMBER.text"
                if re.findall(r".*\.\d*\..*", field):
                    # We are dealing with a list of objects
                    # Get dataframe for the list (strip the number from the field name)
                    list_field = str(field.split('.')[0])
                    list_index = int(field.split('.')[1])
                    sub_field = str(field.split('.')[2])
                    dataframe_name = str(topic) + "/" + list_field
                    # Check if the dataframe has already been created
                    if dataframe_name not in dataframe_dict:
                        # Create the dataframe (avoids overwriting the dataframe if multiple fields are in the same list)
                        dataframe_dict[dataframe_name] = get_dataframe(reader, topic, [list_field])
                    # iterate though each row and add a column for each field in the message
                    for index, row in dataframe_dict[dataframe_name].iterrows():
                        for i in range(0,len(row[list_field])):
                            if i == list_index:
                                dataframe_dict[dataframe_name].at[index,f"{list_field}.{i}.{sub_field}"] = get_attribute(row[list_field][i], sub_field)
                    # Save the name of the field that contains the list to remove it from the dataframe after the iteration
                    if (dataframe_name, list_field) not in things_to_remove:
                        things_to_remove.append((dataframe_name, list_field))
                else:
                    dataframe_dict[str(topic) + "/" + str(field)] = get_dataframe(reader, topic, [field])
            # print(dataframe_dict[topic])
        except Exception as e:
            print(e)
            # Remove that topic from the list
            print(f"WARNING : {topic} has no messages")
            # topics.remove(topic)
            continue

# Remove the list fields from the dataframe
for dataframe_name, list_field in things_to_remove:
    dataframe_dict[dataframe_name] = dataframe_dict[dataframe_name].drop(columns=[list_field])

# # How to access header
# if "/gnss/syncrho" in filtered_message_types:
#     with AnyReader([Path(rosbag_dir)]) as reader:
#         dataframe_dict["/gnss/syncrho"] = get_dataframe(reader, '/gnss/syncrho', ['observable'])

#         # iterate though each row and add a column for each field in the message
#         for index, row in dataframe_dict["/gnss/syncrho"].iterrows():
#             for i in range(0,len(row['observable'])):
#                 for field in filtered_message_types['/gnss/syncrho']:
#                     if field != "observable":
#                         dataframe_dict["/gnss/syncrho"].at[index,f"observable.{i}.{field}"] = get_attribute(row['observable'][i], field)


        # unpack column into multiple columns
        # dataframe = dataframe.explode('observable')
        # dataframe = dataframe["observable"].apply(lambda x: pd.Series([get_attribute(x, field) for field in message_types['/gnss/syncrho'] if field != "observable"]))


print(dataframe_dict)
# Merge all pandas dataframes into one column-wise
dataframe = pd.concat(dataframe_dict, axis=1)
# Interpolate missing values
if args.interpolate:
    dataframe = dataframe.interpolate(method='linear', axis=0).ffill().bfill()
# Save to pickle
if args.output:
    dataframe.to_csv(args.output)
else:
    dataframe.to_csv(f"{rosbag_dir}/dataframe.csv")
