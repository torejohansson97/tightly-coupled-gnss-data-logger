# NAV-TIMEGPS (0x01 0x20)
# GPS Time Solution
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 32

uint32 itow             # GPS Millisecond time of week [ms]
int32 ftow              # Fractional Nanoseconds remainder of rounded
                        # ms above, range -500000 .. 500000 [ns]
int16 week              # GPS week (GPS time)

int8 leaps              # Leap Seconds (GPS-UTC) [s]

uint8 valid             # Validity Flags
uint8 VALID_TOW = 1        # Valid Time of Week
uint8 VALID_WEEK = 2       # Valid Week Number
uint8 VALID_LEAP_S = 4     # Valid Leap Seconds

uint32 tacc             # Time Accuracy Estimate [ns]
