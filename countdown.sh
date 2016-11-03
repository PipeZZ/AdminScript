#!/bin/bash 

declare -i count=0

### Functions
function usage {
  echo "Usage: $0 [-h] [-c numberofseconds]"
}

function error-message {
  echo "$@" >&2
}

#Function to restart the countdown
function ctrl_c {
  echo "The Countdown will now restart"
  COUNTER=$count
}

### Command line processing
while [ $# -gt 0 ]; do
  case "$1" in

    -h )
      usage
      exit 0
      ;;
    -c )
      if [ "$2" -lt 31 ]; then
        count=$2
        shift
      else
        error-message "You gave me '$2' seconds to countdown from, THE MAX IS 30"
        exit 1
	fi
	;;
    * )
	error-message "What do you mean '$1', Theres no '$1' HERE"
	usage
	exit 1
	;;
  esac
  shift
done

trap ctrl_c INT
trap 'exit 0' 3

### USER INPUT
# get a valid second count from the user
  until [ "${count}" -lt 31 -a "${count}" -gt 0 ]; do
  read -p "How many seconds would you like me to countdown from? [1-30] " count
done

### Countdown Timer

COUNTER=$count
while [ $COUNTER -gt 0 ]; do
echo The counter is $COUNTER
let COUNTER=COUNTER-1
sleep 1 
done
