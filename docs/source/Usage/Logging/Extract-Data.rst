Extract Data
===============

Once a recording as been made, the data can be extracted from the output SQL database
using the extract_data.py script. This script will extract the data from the database
and save it in a CSV file. The CSV file can then be used for further analysis.

The script can be run as follows:

    python extract_database.py --input ~/rosbag/NAME_OF_RECORDING --msg_path ~/tightly-coupled-datalogger/src/scripts/messages -o OUTPUT_PATH.csv

Where NAME_OF_RECORDING is the folder enclosing the database file (not the .db3 file itself).