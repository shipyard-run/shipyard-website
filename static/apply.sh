#!/bin/bash

# check there is a valid argument
if [[ $1 == "" ]]; then
  echo "You must specify a blueprint to apply"
  exit 1
fi

# Check that shipyard is installed if not install it
if ! [ -x "$(command -v yard)" ]; then
  ./install.sh
fi

#
yard apply $1
