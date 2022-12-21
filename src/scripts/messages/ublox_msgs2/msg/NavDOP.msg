# NAV-DOP (0x01 0x04)
# Dilution of precision
#
# - DOP values are dimensionless.
# - All DOP values are scaled by a factor of 100. If the unit transmits a value 
#   of e.g. 156, the DOP value is 1.56.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 4

uint32 itow             # GPS Millisecond Time of Week [ms]

uint16 gdop             # Geometric DOP [1 / 0.01]
uint16 pdop             # Position DOP  [1 / 0.01]
uint16 tdop             # Time DOP [1 / 0.01]
uint16 vdop             # Vertical DOP [1 / 0.01]
uint16 hdop             # Horizontal DOP [1 / 0.01]
uint16 ndop             # Northing DOP [1 / 0.01]
uint16 edop             # Easting DOP [1 / 0.01]
