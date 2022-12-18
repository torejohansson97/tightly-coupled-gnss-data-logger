"""Read a pandas database and display it in DTale."""

import argparse
from pathlib import Path
import dtale
import pandas as pd


# Register custom types
from rosbags.typesys import get_types_from_msg, register_types, generate_msgdef



add_types = {}

for messages in [
    ('/Users/zach-mcc/Documents/KTH/GNSS-Datalogger/src/gnss-sdr-ros/msg/GNSSSynchro.msg', "gnss_sdr2/msg/GNSSSynchro"),
    ('/Users/zach-mcc/Documents/KTH/GNSS-Datalogger/src/gnss-sdr-ros/msg/Observables.msg', "gnss_sdr2/msg/Observables"),
    ('/Users/zach-mcc/Documents/KTH/GNSS-Datalogger/src/gnss-sdr-ros/msg/MonitorPvt.msg', "gnss_sdr2/msg/MonitorPvt"),
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

# Receive a filename from the command line
parser = argparse.ArgumentParser(description='Read pandas database and display it in DTale.')
parser.add_argument('--input','-i',type=str, help='pandas database input location')
args = parser.parse_args()

db_filename = args.input

# Read the pickle file
df = pd.read_pickle(db_filename)

# Display the dataframe in DTale
d = dtale.show(df, subprocess=False)