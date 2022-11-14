### Setup of GNSS-SDR with LimeSDR on Ubuntu 20.04

## Installation of the dependencies

sudo apt-get install build-essential cmake git pkg-config libboost-dev \
   libboost-date-time-dev libboost-system-dev libboost-filesystem-dev \
   libboost-thread-dev libboost-chrono-dev libboost-serialization-dev \
   libboost-program-options-dev libboost-test-dev liblog4cpp5-dev \
   libuhd-dev gnuradio-dev gr-osmosdr libblas-dev liblapack-dev \
   libarmadillo-dev libgflags-dev libgoogle-glog-dev libhdf5-dev \
   libgnutls-openssl-dev libmatio-dev libpugixml-dev libpcap-dev \
   libprotobuf-dev protobuf-compiler libgtest-dev googletest \
   python-mako python-six


## General Setup of GNSS-SDR

git clone https://github.com/gnss-sdr/gnss-sdr  
cd gnss-sdr/build  
git checkout next  
cmake ..  
make  
sudo make install  

volk_profile  
volk_gnsssdr_profile  

## Setup of LimeSDR for GNSS-SDR

# Setup of SoadySDR and limesuite

sudo add-apt-repository -y ppa:myriadrf/drivers  
sudo apt-get update  
sudo apt-get install limesuite liblimesuite-dev limesuite-udev limesuite-images  
sudo apt-get install soapysdr soapysdr-module-lms7  
(or sudo apt-get install soapysdr-tools soapysdr-module-lms7) #have to check not sure yet  

# Setup of LimeSDR

sudo apt-get install gr-limesdr  
cd gnss-sdr/build  
git checkout next  
git pull upstream next  
cmake -DENABLE_LIMESDR=ON ..  
make && sudo make install  

## Creation of the configuration file



### How to launch the acquisition

./limesdr with config file  



