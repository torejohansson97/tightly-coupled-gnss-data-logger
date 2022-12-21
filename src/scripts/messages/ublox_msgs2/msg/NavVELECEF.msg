# NAV-VELECEF (0x01 0x11)
# Velocity Solution in ECEF
#
# See important comments concerning validity of velocity given in section
# Navigation Output Filters.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 17

uint32 itow             # GPS Millisecond time of week [ms]

int32 ecefvx            # ECEF X velocity [cm/s]
int32 ecefvy            # ECEF Y velocity [cm/s]
int32 ecefvz            # ECEF Z velocity [cm/s]
uint32 sacc             # Speed Accuracy Estimate [cm/s]
