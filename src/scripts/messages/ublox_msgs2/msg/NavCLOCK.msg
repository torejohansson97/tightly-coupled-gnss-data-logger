# NAV-CLOCK (0x01 0x22)
# Clock Solution
#

uint8 CLASS_ID = 1
uint8 MESSAGE_ID = 34

uint32 itow             # GPS Millisecond Time of week [ms]

int32 clkb              # Clock bias in nanoseconds [ns]
int32 clkd              # Clock drift in nanoseconds per second [ns/s]
uint32 tacc             # Time Accuracy Estimate [ns]
uint32 facc             # Frequency Accuracy Estimate [ps/s]
