#!/bin/bash

#Create an array using the output of ifconfig which has the names of
#the network interfaces in it. Use those names to extract the ip 
#addresses of the interfaces, also using ifconfig output. 
#Parse the output of route -n to display the ip address of the default gateway.

ethernet=(`ifconfig |grep '^eth0'|awk '{print $1}'`)
loopback=(`ifconfig |grep '^lo'|awk '{print $1}'`)
gatewayip=`route -n|grep '^0.0.0.0 '|awk '{print $2}'`

declare -a ips
ips[0]=`ifconfig ${ethernet} | grep 'inet addr' |
                                     sed -e 's/  *inet addr://'| sed -e 's/ .*//'`

ips[1]=`ifconfig ${loopback} | grep 'inet addr' |
                                     sed -e 's/  *inet addr://'| sed -e 's/ .*//'`


### Functions
function usage {
   echo "Usage: $0 [-h|--help] [-r|--route gateway loop eth0]"
}

function error-message {
   echo "$@" >&2
}


### Command Line Processing
while [ $# -gt 0 ]; do
   case "$1" in
   -h | --help ) #Show usage
	usage
	exit 0
	;;
   -r | --route ) #select interface name to display
     if [ "$2" == gateway ]; then
	echo "My default gateway is $gatewayip"
   else
     if [ "$2" == eth0 ]; then
	echo "Interface ${ethernet} has address ${ips[0]}"
   else
     if [ "$2" == loop ]; then
	echo "Interface ${loopback} has address ${ips[1]}"
   else
     error-message "You gave me $2 when you should have given me either, gateway, eth0, or loop"
	exit 1
     fi
     fi
     fi
	;;
   esac
   shift
done

	echo "My default gateway is $gatewayip"
	echo "Interface ${ethernet} has address ${ips[0]}"
	echo "Interface ${loopback} has address ${ips[1]}"
