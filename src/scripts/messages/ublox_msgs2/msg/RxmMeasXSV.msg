#see message RxmMeasX #

uint8 gnssid            # GNSS ID
uint8 svid              # Satellite ID
uint8 cno               # carrier noise ratio (0..63)

uint8 mpathindic        # Multipath index (0=not measured, 1=low, 2=medium, 3=high)

int32 dopplerms         # Doppler Measurement
int32 dopplerhz         # Doppler measurement

uint16 wholechips       # Whole value of the code phase measurement (0..1022 for GPS)
uint16 fracchips        # Fractional value of the code phase measurement(0..1023)

uint32 codephase        # Code Phase
uint8 intcodephase      # Integer (part of the) code phase

uint8 pseurangermserr   # Pseudorange RMS error index(0..63)

uint8[2] reserved4      # Reserved
