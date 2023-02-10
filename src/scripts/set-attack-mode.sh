#!/bin/bash

if [ "$1" == "on" ]; then
  bash /home/master/tightly-coupled-gnss-data-logger/src/scripts/gpio_config.sh -o 1
elif [ "$1" == "off" ]; then
  bash /home/master/tightly-coupled-gnss-data-logger/src/scripts/gpio_config.sh -o 0
elif [ "$1" == "status" ]; then
    bash /home/master/tightly-coupled-gnss-data-logger/src/scripts/gpio_config.sh -s
else
  echo "Invalid argument. Use 'on' or 'off' to set the state or 'status' to get the current state."
fi