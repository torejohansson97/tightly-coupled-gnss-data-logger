# CFG-DAT (0x06 0x06)
# Set User-defined Datum
# 
# For more information see the description of Geodetic Systems and Frames.
# 

uint8 CLASS_ID = 6
uint8 MESSAGE_ID = 6

# Only for GET, these values are not used for write
uint16 datumnum       # Datum Number: 0 = WGS84, 0xFFFF = user-defined
uint16 DATUM_NUM_WGS84 = 0
uint16 DATUM_NUM_USER = 65535

uint8[6] datumname    # ASCII String: WGS84 or USER

float64 maja          # Semi-major Axis [m]
                      # accepted range = 6,300,000.0 to 6,500,000.0 meters 
float64 flat          # 1.0 / Flattening 
                      # accepted range is 0.0 to 500.0

float32 dx            # X Axis shift at the origin [m]
                      # accepted range is +/- 5000.0 meters 
float32 dy            # Y Axis shift at the origin [m]
                      # accepted range is +/- 5000.0 meters 
float32 dz            # Z Axis shift at the origin [m]
                      # accepted range is +/- 5000.0 meters 

float32 rotx          # Rotation about the X Axis [s]
                      # accepted range is +/- 20.0 milli-arc seconds 
float32 roty          # Rotation about the Y Axis [s]
                      # accepted range is +/- 20.0 milli-arc seconds 
float32 rotz          # Rotation about the Z Axis [s]
                      # accepted range is +/- 20.0 milli-arc seconds

float32 scale         # Scale change [ppm]
                      # accepted range is 0.0 to 50.0 parts per million