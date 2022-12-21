# NAV-SOL (0x01 0x06)
# Navigation Solution Information
#
# This message combines Position, velocity and time solution in ECEF, including 
# accuracy figures
# This message has only been retained for backwards compatibility; users are 
# recommended to use the UBX-NAV-PVT message in preference.
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 6

uint32 itow             # GPS Millisecond time of week [ms]
int32 ftow              # Fractional Nanoseconds remainder of rounded
                        # ms above, range -500000 .. 500000 [ns]
int16 week              # GPS week (GPS time)

uint8 gpsfix            # GPSfix Type, range 0..5
uint8 GPS_NO_FIX = 0
uint8 GPS_DEAD_RECKONING_ONLY = 1
uint8 GPS_2D_FIX = 2
uint8 GPS_3D_FIX = 3
uint8 GPS_GPS_DEAD_RECKONING_COMBINED = 4
uint8 GPS_TIME_ONLY_FIX = 5

uint8 flags             # Fix Status Flags
uint8 FLAGS_GPS_FIX_OK = 1      # Fix within limits i.e. within DOP & ACC Masks
uint8 FLAGS_DIFF_SOLN = 2       # DGPS used
uint8 FLAGS_WKNSET = 4          # Week Number valid
uint8 FLAGS_TOWSET = 8          # Time of Week valid

int32 ecefx             # ECEF X coordinate [cm]
int32 ecefy             # ECEF Y coordinate [cm]
int32 ecefz             # ECEF Z coordinate [cm]
uint32 pacc             # 3D Position Accuracy Estimate [cm]
int32 ecefvx            # ECEF X velocity [cm/s]
int32 ecefvy            # ECEF Y velocity [cm/s]
int32 ecefvz            # ECEF Z velocity [cm/s]
uint32 sacc             # Speed Accuracy Estimate [cm/s]
uint16 pdop             # Position DOP [1 / 0.01]
uint8 reserved1         # Reserved
uint8 numsv             # Number of SVs used in Nav Solution
uint32 reserved2        # Reserved
