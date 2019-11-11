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
ip a add 192.168.1.1/24 broadcast 192.168.1.255 dev br-home

#Work around for Ethernet connected clients
brctl addif brlan0 lan0
brctl addif brlan0 lan1
brctl addif brlan0 lan2
brctl addif brlan0 lan3
brctl addif brlan0 lan4

ifconfig eth1 up
ifconfig lan0 up
ifconfig lan1 up
ifconfig lan2 up
ifconfig lan3 up
ifconfig lan4 up

MAC=`cat /sys/class/net/wlan0/address`
BH_2G_INF=wlan12
iw dev wlan0 interface add BH_2G_INF type __ap addr "00:`echo $MAC | cut -d ':' -f2,3,4,5,6 --output-delimiter=':'`"
ip link set BH_2G_INF mtu 1600
ip a add 169.254.0.1/24 broadcast 169.254.0.255 dev BH_2G_INF

MAC=`cat /sys/class/net/wlan1/address`
BH_5G_INF=wlan13
iw dev wlan1 interface add BH_5G_INF type __ap addr "00:`echo $MAC | cut -d ':' -f2,3,4,5,6 --output-delimiter=':'`"
ip link set BH_5G_INF mtu 1600
ip a add 169.254.1.1/24 broadcast 169.254.1.255 dev BH_5G_INF

exit 0
