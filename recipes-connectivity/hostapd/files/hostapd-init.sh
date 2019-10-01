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

if [ ! -f /nvram/bw_file.txt ]
then
	cp /etc/bw_file.txt /nvram/bw_file.txt
fi

brctl addbr brlan0
exit 0

