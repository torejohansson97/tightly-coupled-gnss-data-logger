# CFG-NAVX5 (0x06 0x23)
# Navigation Engine Expert Settings
#
# Warning: Refer to u-blox protocol spec before changing these settings.

uint8 CLASS_ID = 6
uint8 MESSAGE_ID = 35

uint16 version        # Message version (set to 0)

uint16 mask1          # First parameters bitmask (possible values below)
uint16 MASK1_MIN_MAX        = 4        # apply min/max SVs settings
uint16 MASK1_MIN_CNO        = 8        # apply minimum C/N0 setting
uint16 MASK1_INITIAL_FIX_3D = 64       # apply initial 3D fix settings
uint16 MASK1_WKN_ROLL       = 512      # apply GPS week number rollover settings
uint16 MASK1_ACK_AID        = 1024     # apply assistance acknowledgment 
                                       # settings
uint16 MASK1_PPP            = 8192     # apply useppp flag
uint16 MASK1_AOP            = 16384    # apply aopcfg (useAOP flag) and 
                                       # aoporbmaxerr settings
                                       # (AssistNow Autonomous)

uint32 mask2          # Second parameters bitmask (possible values below)
                      # Firmware >=8 only
uint32 MASK2_ADR = 64                    # Apply ADR sensor fusion on/off 
                                         # setting
uint32 MASK2_SIG_ATTEN_COMP_MODE = 128   # Apply signal attenuation 
                                         # compensation feature settings

uint8[2] reserved1      # Always set to zero

uint8 minsvs            # Minimum number of satellites for navigation
uint8 maxsvs            # Maximum number of satellites for navigation
uint8 mincno            # Minimum satellite signal level for navigation [dBHz]

uint8 reserved2         # Always set to zero

uint8 inifix3d          # If set to 1, initial fix must be 3D

uint8[2] reserved3      # Always set to zero

uint8 ackaiding         # If set to 1, issue acknowledgments for assistance
uint16 wknrollover      # GPS week rollover number, GPS week numbers will be set 
                        # correctly from this week up to 1024 weeks after this 
                        # week
uint8 sigattencompmode  # Permanently attenuated signal compensation [dBHz]
                        # 0 = disabled, 255 = automatic
                        # 1..63 = maximum expected C/N0 value
                        # Firmware 8 only

uint8[5] reserved4      # Always set to zero

uint8 useppp            # Enable/disable PPP (on supported units)
uint8 aopcfg            # AssistNow Autonomous configuration, 1: enabled

uint8[2] reserved5      # Always set to zero

uint16 aoporbmaxerr     # Maximum acceptable (modeled) autonomous orbit 
                        # error [m]
                        # valid range = 5..1000
                        # 0 = reset to firmware default

uint8[7] reserved6      # Always set to zero

uint8 useadr            # Enable/disable ADR sensor fusion 
                        # 1: enabled, 0: disabled
                        # Only supported on certain products 
