# GnssSynchro represents the processing measurements at a given time taken by a given processing channel
# Based on https://github.com/gnss-sdr/gnss-sdr/blob/next/docs/protobuf/gnss_synchro.proto

Header header

string system   # GNSS constellation: "G" for GPS, "R" for Glonass, "S" for SBAS, "E" for Galileo and "C" for Beidou.
string signal   # GNSS signal: "1C" for GPS L1 C/A, "1B" for Galileo E1b/c, "1G" for Glonass L1 C/A, "2S" for GPS L2 L2C(M), "2G" for Glonass L2 C/A, "L5" for GPS L5 and "5X" for Galileo E5a

uint32 prn          # GNSS satellite PRN number
int32 channel_id    # GNSS channel number

float64 acq_delay_samples  # Coarse code delay estimation, in samples
float64 acq_doppler_hz  # Coarse Doppler estimation in each channel, in Hz
uint64 acq_samplestamp_samples  # Number of samples at signal SampleStamp
uint32 acq_doppler_step  # Step of the frequency bin in the search grid, in Hz
bool flag_valid_acquisition  # Acquisition status

int64 fs  # Sampling frequency, in samples per second
float64 prompt_i  # In-phase (real) component of the prompt correlator output
float64 prompt_q  # Quadrature (imaginary) component of the prompt correlator output
float64 cn0_db_hz  # Carrier-to-Noise density ratio, in dB-Hz
float64 carrier_doppler_hz  # Doppler estimation, in [Hz].
float64 carrier_phase_rads  # Carrier phase estimation, in rad
float64 code_phase_samples  # Code phase in samples
uint64 tracking_sample_counter  # Sample counter indicating the number of processed samples
bool flag_valid_symbol_output  # Indicates the validity of signal tracking
int32 correlation_length_ms  # Time duration of coherent correlation integration, in ms

bool flag_valid_word  # Indicates the validity of the decoded navigation message word
uint32 tow_at_current_symbol_ms  # Time of week of the current symbol, in ms

float64 pseudorange_m  # Pseudorange computation, in m
float64 rx_time  # Receiving time after the start of the week, in s
bool flag_valid_pseudorange  # Pseudorange computation status
float64 interp_tow_ms  # Interpolated time of week, in ms
bool flag_PLL_180_deg_phase_locked # PLL lock at 180º

