# CFG-NMEA (0x06 0x17)
# NMEA protocol configuration V0
#
# Set/Get the NMEA protocol configuration. See section NMEA Protocol 
# Configuration for a detailed description of the configuration effects on 
# NMEA output
#
# Supported on: u-blox 7 firmware version 1.00
#

uint8 CLASS_ID = 6
uint8 MESSAGE_ID = 23 

uint8 filter                  # filter flags
uint8 FILTER_POS = 1          # Enable position output for failed or 
                              # invalid fixes
uint8 FILTER_MSK_POS = 2      # Enable position output for invalid fixes
uint8 FILTER_TIME = 4         # Enable time output for invalid times
uint8 FILTER_DATE = 8         # Enable date output for invalid dates
uint8 FILTER_GPS_ONLY = 16    # Restrict output to GPS satellites only
uint8 FILTER_TRACK = 32       # Enable COG output even if COG is frozen

uint8 nmeaversion             # NMEA version
uint8 NMEA_VERSION_2_3 = 35     # Version 2.3
uint8 NMEA_VERSION_2_1 = 33     # Version 2.1

uint8 numsv                   # Maximum Number of SVs to report per TalkerId: 
                              # unlimited (0) or 8, 12, 16
uint8 NUM_SV_UNLIMITED = 0 

uint8 flags                   # flags
uint8 FLAGS_COMPAT = 1          # enable compatibility mode.
                                # This might be needed for certain applications  
                                # when customer's NMEA parser expects a fixed 
                                # number of  digits in position coordinates
uint8 FLAGS_CONSIDER = 2        # enable considering mode

uint32 gnsstofilter           # Filters out satellites based on their GNSS.  
                              # If a bitfield is enabled, the corresponding 
                              # satellites will be not output.
uint32 GNSS_TO_FILTER_GPS = 1       # Disable reporting of GPS satellites
uint32 GNSS_TO_FILTER_SBAS = 2      # Disable reporting of SBAS satellites
uint32 GNSS_TO_FILTER_QZSS = 16     # Disable reporting of QZSS satellites
uint32 GNSS_TO_FILTER_GLONASS = 32  # Disable reporting of GLONASS satellites

uint8 svnumbering             # Configures the display of satellites that do not  
                              # have an NMEA-defined value. Note: this does not
                              # apply to satellites with an unknown ID.
uint8 SV_NUMBERING_STRICT = 0     # Strict - Satellites are not output
uint8 SV_NUMBERING_EXTENDED = 1   # Extended - Use proprietary numbering

uint8 maintalkerid            # By default the main Talker ID (i.e. the Talker 
                              # ID used  for all messages other than GSV) is 
                              # determined by the  GNSS assignment of the 
                              # receiver's channels (see CfgGNSS). 
                              # This field enables the main Talker ID to be 
                              # overridden
uint8 MAIN_TALKER_ID_NOT_OVERRIDDEN = 0   # Main Talker ID is not overridden
uint8 MAIN_TALKER_ID_GP = 1               # Set main Talker ID to 'GP'
uint8 MAIN_TALKER_ID_GL = 2               # Set main Talker ID to 'GL'
uint8 MAIN_TALKER_ID_GN = 3               # Set main Talker ID to 'GN'

uint8 gsvtalkerid             # By default the Talker ID for GSV messages is  
                              # GNSS specific (as defined by NMEA). This field 
                              # enables the GSV Talker ID to be overridden.
uint8 GSV_TALKER_ID_GNSS_SPECIFIC = 0   # Use GNSS specific Talker ID 
                                        # (as defined by NMEA)
uint8 GSV_TALKER_ID_MAIN = 1            # Use the main Talker ID

uint8 reserved              # Reserved