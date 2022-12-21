# RXM-MEASX(0x02 0x14) #
# Satellite  measurement for RRLP

# The message payload data is, where possible and appropriate, according to the Radio Resource LCS (Location
# Services) Protocol (RRLP). One exception is the satellite and GNSS IDs, which here are given according to
# the Satellite Numbering scheme. The correct satellites have to be selected and their satellite ID translated
# accordingly [1, tab. A.10.14] for use in a RRLP Measure Position Response Component. Similarly, the
# measurement reference time of week has to be forwarded correctly (modulo 14400000 for the 24 LSB GPS
# measurements variant, modulo 3600000 for the 22 LSB Galileo and Additional Navigation Satelllite Systems
# (GANSS) measurements variant) of the RRLP measure position response to the SMLC.


uint8 CLASS_ID = 2
uint8 MESSAGE_ID = 20

uint8 version           # Message version

uint8[3] reserved0      # Reserved 0

uint32 gpstow           # GPS measurement reference time
uint32 glotow           # GLONASS measurement reference time
uint32 bdstow           # BeiDou measurement reference time

uint8[4] reserved1      # Reserved 1

uint32 qzsstow          # QZSS measurement reference time
uint16 gpstowacc        # GPS measurement reference time accuracy (0xffff => 4s)
uint16 glotowacc        # GLONASS measurement reference time accuracy (0xffff => 4s)
uint16 bdstowacc        # BeiDou measurement reference time accuracy (0xffff => 4s)

uint8[2] reserved2      # Reserved 2

uint16 qzsstowacc       # QZSS measurement reference time accuracy (0xffff => 4s)
uint8 numsv             # Number of satellites in repeated block

uint8 flags             # Flags
uint8 FLAGS_TOWSET = 3  # TOW set (0=no, 1 or 2=yes)

uint8[8] reserved3      # Reserved 3

RxmMeasXSV[] sv
