# NAV-POSLLH (0x01 0x02)
# Geodetic Position Solution
#
# See important comments concerning validity of position given in section
# Navigation Output Filters.
# This message outputs the Geodetic position in the currently selected 
# Ellipsoid. The default is the WGS84 Ellipsoid, but can be changed with the
# message CFG-DAT.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 2

uint32 itow             # GPS Millisecond Time of Week [ms]

int32 lon               # Longitude [deg / 1e-7]
int32 lat               # Latitude [deg / 1e-7]
int32 height            # Height above Ellipsoid [mm]
int32 hmsl              # Height above mean sea level [mm]
uint32 hacc             # Horizontal Accuracy Estimate [mm]
uint32 vacc             # Vertical Accuracy Estimate [mm]
