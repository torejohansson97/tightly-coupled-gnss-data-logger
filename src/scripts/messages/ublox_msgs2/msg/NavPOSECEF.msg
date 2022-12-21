# NAV-POSECEF (0x01 0x01)
# Position Solution in ECEF
#
# See important comments concerning validity of position given in section
# Navigation Output Filters.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 1

uint32 itow             # GPS Millisecond Time of Week [ms]

int32 ecefx             # ECEF X coordinate [cm]
int32 ecefy             # ECEF Y coordinate [cm]
int32 ecefz             # ECEF Z coordinate [cm]
uint32 pacc             # Position Accuracy Estimate [cm]
