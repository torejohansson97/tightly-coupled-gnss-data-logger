# NAV-SAT (0x01 0x35)
# Satellite Information
#
# This message displays information about SVs which are either known to be 
# visible or currently tracked by the receiver.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 53

uint32 itow                # GPS time of week of the navigation epoch. [ms]
uint8 version              # Message version (1 for this version)
uint8 numsvs               # Number of satellites
uint8[2] reserved0         # Reserved 

# start of repeated block (numsvs times)
NavSATSV[]  sv
# end of repeated block