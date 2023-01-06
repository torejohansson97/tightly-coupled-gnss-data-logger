import argparse
import pandas as pd
import folium


# Receive a filename from the command line
parser = argparse.ArgumentParser(description='Read latitude and longitud from CSV and plot on a map.')
parser.add_argument('--input','-i',type=str, help='CSV input location')
args = parser.parse_args()

csv_filename = args.input

# Read in csv file of latitude and longitude and plot the on a map
df = pd.read_csv(csv_filename)

# drop the zeroth row from the pandas dataframe
df = df.drop([0])

# convert the latitude and longitude columns to float
df['/ublox_raw/navpvt/lat'] = df['/ublox_raw/navpvt/lat'].astype(float)
df['/ublox_raw/navpvt/lon'] = df['/ublox_raw/navpvt/lon'].astype(float)

latitudes = df['/ublox_raw/navpvt/lat'] / 1e7
longitudes = df['/ublox_raw/navpvt/lon'] / 1e7


# print(latitudes)

# Get the center of the map
latitude_center = latitudes.mean()
longitude_center = longitudes.mean()

map = folium.Map(location=[latitude_center, longitude_center], zoom_start=12)

# # Draw the path on the map
folium.PolyLine(locations=list(zip(latitudes, longitudes)), color="red", weight=2.5, opacity=1).add_to(map)

map.save('map.html')