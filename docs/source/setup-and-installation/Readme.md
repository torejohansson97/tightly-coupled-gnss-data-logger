# Setup of GNSS-SDR with LimeSDR on Ubuntu 20.04

## Installation of GNSS SDR

Install of GNSS SDR explained here: https://gnss-sdr.org/build-and-install/

### Installation of the dependencies

      sudo apt-get install build-essential cmake git pkg-config libboost-dev libboost-date-time-dev libboost-system-dev \
      libboost-filesystem-dev  libboost-thread-dev libboost-chrono-dev libboost-serialization-dev libboost-program-options-dev \
      libboost-test-dev liblog4cpp5-dev libuhd-dev gnuradio-dev gr-osmosdr libblas-dev liblapack-dev libarmadillo-dev libgflags-dev \
      libgoogle-glog-dev libhdf5-dev libgnutls-openssl-dev libmatio-dev libpugixml-dev libpcap-dev libprotobuf-dev protobuf-compiler \
      libgtest-dev googletest python-mako python-six

### Installation of GNSS-SDR

      git clone https://github.com/gnss-sdr/gnss-sdr  
      cd gnss-sdr/build  
      git checkout next  
      cmake ..  
      make  
      sudo make install
      
### Performance boost - Allows the use of SIMD instructions (do only once)

      volk_profile  
      volk_gnsssdr_profile  

## Installation of LimeSDR sofwtare for GNSS SDR

### Installation of SoapySDR and Limesuite

      sudo add-apt-repository -y ppa:myriadrf/drivers  
      sudo apt-get update  
      sudo apt-get install limesuite liblimesuite-dev limesuite-udev limesuite-images  
      sudo apt-get install soapysdr-tools soapysdr-module-lms7

Installation of LimeSDR and Limesuite explained here : https://wiki.myriadrf.org/Installing_Lime_Suite_on_Linux

### Installation of LimeSDR module for GNSS-SDR

      cd  
      sudo apt-get install gr-limesdr  
      cd gnss-sdr/build  
      git checkout next  
      git pull upstream next  
      cmake -DENABLE_LIMESDR=ON ..  
      make && sudo make install  
      
Installation of LimeSDR for GNSS SDR explained here : https://gnss-sdr.org/docs/sp-blocks/signal-source/#implementation-limesdr_signal_source

## Setup of the monitoring blocks (PVT monitoring and GNSS Synchro)

### GNSS Synchro monitor

Installation of the GNSS Synchro monitoring block explained here : https://gnss-sdr.org/docs/sp-blocks/monitor/

Installation of dependencies

       sudo apt-get install build-essential cmake libboost-dev libboost-system-dev libprotobuf-dev protobuf-compiler libncurses5-dev libncursesw5-dev wget  
       
Create a monitoring-client folder and download the required files 

       mkdir monitoring-client  
       cd monitoring-client  
       wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/monitoring-client/gnss_synchro_udp_source.h  
       wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/monitoring-client/gnss_synchro_udp_source.cc
       wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/monitoring-client/main.cc
       wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/monitoring-client/CMakeLists.txt
       wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/monitoring-client/gnss_synchro.proto
       mkdir build
       cd build  
       cmake ../  
       make  

### PVT Monitoring

PVT monitoring block explained here :https://github.com/acebrianjuan/gnss-sdr-pvt-monitoring-client

      cd
      git clone https://github.com/acebrianjuan/gnss-sdr-pvt-monitoring-client.git
      cd gnss-sdr-pvt-monitoring-client/build  
      cmake ../  
      make  


## Configuration file for acquisition

Create a working directory for GNSS SDR

      mkdir work
      
Download the configuration file for live acquisition with limesdr

      wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/GNSS-SDR/limeSDR.conf
      
Or download the configuration file to replay acquisition with a file of raw data

      wget https://raw.githubusercontent.com/torejohansson97/tightly-coupled-gnss-data-logger/main/GNSS-SDR/Filedump.conf
      wget https://sourceforge.net/projects/gnss-sdr/files/data/2013_04_04_GNSS_SIGNAL_at_CTTC_SPAIN.tar.gz
      tar -zxvf 2013_04_04_GNSS_SIGNAL_at_CTTC_SPAIN.tar.gz
      
The path to the raw data file is labeled as "SignalSource.filename=" in the configuration file
## How to launch the GNSS SDR

      gnss-sdr --config-file=./<Path to config file>
Or go to https://gnss-sdr.org/my-first-fix/ for more explanation on how to make GNSS SDR work


## How to launch PVT Monitoring client

Open new terminal and go to /gnss-sdr-pvt-monitoring-client/build

      ./gnss-sdr-pvt-monitoring-client <Port defined in config file> (1111 for the one on github)

## How to launch GNSS Synchro monitoring client

Open new terminal and go to /monitoring-client/build

      ./monitoring-client <Port defined in config file> (1234 for the one on github)
