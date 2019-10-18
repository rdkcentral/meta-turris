#!/bin/sh

if [ ! -f /nvram/hostapd0.conf ]
then
	cp /etc/hostapd-2G.conf /nvram/hostapd0.conf
	cp /etc/hostapd-5G.conf /nvram/hostapd1.conf

	#Change the bssid for wlan0
	MAC=`cat /sys/class/net/wlan0/address`
	sed -i "/^bssid=/c\bssid=${MAC}"  /nvram/hostapd0.conf

	#Change the bssid for wlan1
	MAC=`cat /sys/class/net/wlan1/address`
	sed -i "/^bssid=/c\bssid=${MAC}"  /nvram/hostapd1.conf
fi

if [ ! -f /sys/class/net/brlan0 ]
then
	brctl addbr brlan0
fi
ip link set brlan0 address `cat /sys/class/net/eth1/address`

if [ ! -f /sys/class/net/br-home ]
then
	brctl addbr br-home
fi
ip link set br-home address `cat /sys/class/net/wlan0/address`

MAC=`cat /sys/class/net/wlan0/address`
iw dev wlan0 interface add wlan12 type __ap addr "00:`echo $MAC | cut -d ':' -f2,3,4,5,6 --output-delimiter=':'`"

MAC=`cat /sys/class/net/wlan1/address`
iw dev wlan0 interface add wlan13 type __ap addr "00:`echo $MAC | cut -d ':' -f2,3,4,5,6 --output-delimiter=':'`"

exit 0
