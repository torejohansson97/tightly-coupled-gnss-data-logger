#  MonitorPvt represents a search query, with pagination options to indicate which results to include in the response
Header header

uint32 tow_at_current_symbol_ms  # Time of week of the current symbol, in ms
uint32 week  # PVT GPS week
float64 rx_time  # PVT GPS time
float64 user_clk_offset  # User clock offset, in s

float64 pos_x  # Position X component in ECEF, expressed in m
float64 pos_y  # Position Y component in ECEF, expressed in m
float64 pos_z  # Position Z component in ECEF, expressed in m
float64 vel_x  # Velocity X component in ECEF, in m/s
float64 vel_y  # Velocity Y component in ECEF, in m/s
float64 vel_z  # Velocity Z component in ECEF, in m/s

float64 cov_xx  # Position variance in the Y component, in m2
float64 cov_yy  # Position variance in the Y component, in m2
float64 cov_zz  # Position variance in the Z component, in m2
float64 cov_xy  # Position XY covariance, in m2
float64 cov_yz  # Position YZ covariance, in m2
float64 cov_zx  # Position ZX covariance, in m2

float64 latitude  # Latitude, in deg. Positive: North
float64 longitude  # Longitude, in deg. Positive: East
float64 height  # Height, in m

uint32 valid_sats  # Number of valid satellites
uint32 solution_status  # RTKLIB solution status
uint32 solution_type  # RTKLIB solution type (0: xyz-ecef, 1: enu-baseline)
float64 ar_ratio_factor  # Ambiguity resolution ratio factor for validation
float64 ar_ratio_threshold  # Ambiguity resolution ratio threshold for validation

float64 gdop  # Geometric Dilution of Precision
float64 pdop  # Position (3D) Dilution of Precision
float64 hdop  # Horizontal Dilution of Precision
float64 vdop  # Vertical Dilution of Precision