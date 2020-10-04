#!/bin/bash

# PIP = Primary IP
# value = memory value in kbs
# Memory_G = Memory in GB
# hname = hostname
# nips = number of IPs
#

########### IP PROFILE START #########
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > temp-IP-10-09-20
PIP=$(ip route get 1 | awk '{for (I=1;I<=NF;I++) if ($I == "src") {print $(I+1)};}')
sed -i "s/$PIP/$PIP(P)/" temp-IP-10-09-20
cat temp-IP-10-09-20 | sort -k 2
########### IP PROFILE END ###############

########### RAM PROFILE START #########
value=$(egrep 'MemTotal' /proc/meminfo | awk '{ print $2 }')
Memory_G=$(expr $value / 1000000)
echo "Memory:  $Memory_G G" 
########### RAM PROFILE END #########
hname=$(hostname)
echo "Hostname:  $hname"

######### CHECK OTP CONFIGURATION START ###########
## Required Files : pam-sshd-sample.conf and ssh-sample.config ##
check1=$(cat pam-sshd-sample.conf | grep pam_radius_auth.so | awk '{ print $3 }' | awk '{$1=$1};1')

if fgrep -i -q "ChallengeResponseAuthentication yes" ssh-sample.config && [ $check1 == "pam_radius_auth.so" ]; then
	echo "OTP = CONFIGURED"
	exit 0
else
	echo "OTP = NOT CONFIGURED"
	exit 2
fi
######### CHECK OTP CONFIGURATION END ###########
