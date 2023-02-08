#!/bin/bash

# Receive arguments
while getopts "i:o:" opt; do
  case $opt in
    i)
      input_file="$OPTARG"
      ;;
    o)
      output_file="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "Input file: $input_file"
echo "Output file: $output_file"

# Activate virtualenv
VENV_NAME="datafram-viz"

if command -v pyenv > /dev/null; then
  eval "$(pyenv init -)"
  pyenv activate "$VENV_NAME"
  python /home/master/tightly-coupled-gnss-data-logger/src/scripts/extract_database.py --input $input_file --msg_path=/home/master/tightly-coupled-gnss-data-logger/src/scripts/messages/ --output $output_file
  # Right after exiting the GUI, deactivate the virtualenv
  pyenv deactivate
else
  echo "pyenv is not installed."
  exit 1
fi
