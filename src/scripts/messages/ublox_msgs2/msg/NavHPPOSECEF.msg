# NAV-HPPOSECEF (0x01 0x13)
# High Precision Position Solution in ECEF
#
# See important comments concerning validity of position given in section
# Navigation Output Filters.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 19

uint8 version
uint8[3] reserved0

uint32 itow             # GPS Millisecond Time of Week [ms]

int32 ecefx             # ECEF X coordinate [cm]
int32 ecefy             # ECEF Y coordinate [cm]
int32 ecefz             # ECEF Z coordinate [cm]

int8 ecefxhp            # ECEF X high precision component [0.1mm]
int8 ecefyhp            # ECEF Y high precision component [0.1mm]
int8 ecefzhp            # ECEF Z high precision component [0.1mm]
uint8 flags

uint32 pacc             # Position Accuracy Estimate [0.1mm]
