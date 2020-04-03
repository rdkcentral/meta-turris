# If not stated otherwise in this file or this component's LICENSE
# file the following copyright and licenses apply:
#
#Copyright [2019] [RDK Management]
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

#!/bin/sh

device_type=`cat /version.txt | grep imagename | cut -d':' -f2 | cut -d'-' -f3`
echo "device_type: $device_type"
if [ $device_type == "extender" ];
then
#Workaround: allowing devices initialization
sleep 5;
fi

mkdir -p /nvram
mount /dev/mmcblk0p6 /nvram

WIFI0_MAC=`cat /sys/class/net/wlan0/address`
WIFI1_MAC=`cat /sys/class/net/wlan1/address`
echo "2.4GHz Radio MAC: $WIFI0_MAC"
echo "5GHz   Radio MAC: $WIFI1_MAC"

if [ ! -f /nvram/hostapd0.conf ]
then
	cp /etc/hostapd-2G.conf /nvram/hostapd0.conf
	#Set bssid for wifi0
	sed -i "/^bssid=/c\bssid=`echo $WIFI0_MAC | cut -d ':' -f1,2,3,4,5 --output-delimiter=':'`:00" /nvram/hostapd0.conf
fi

if [ ! -f /nvram/hostapd1.conf ]
then
	cp /etc/hostapd-5G.conf /nvram/hostapd1.conf
	#Set bssid for wifi1
	sed -i "/^bssid=/c\bssid=`echo $WIFI1_MAC | cut -d ':' -f1,2,3,4,5 --output-delimiter=':'`:00" /nvram/hostapd1.conf
fi

if [ ! -f /nvram/hostapd2.conf ]
then
	cp /etc/hostapd-bhaul2G.conf /nvram/hostapd2.conf
	#Set bssid for wifi2
	sed -i "/^bssid=/c\bssid=`echo $WIFI0_MAC | cut -d ':' -f1,2,3,4,5 --output-delimiter=':'`:01" /nvram/hostapd2.conf
fi

if [ ! -f /nvram/hostapd3.conf ]
then
	cp /etc/hostapd-bhaul5G.conf /nvram/hostapd3.conf
	#Set bssid for wifi3
	sed -i "/^bssid=/c\bssid=`echo $WIFI1_MAC | cut -d ':' -f1,2,3,4,5 --output-delimiter=':'`:01" /nvram/hostapd3.conf
fi

if [ $device_type == "extender" ];
then
        exit 0;
fi

#Creating wifi0 and wifi1 AP interfaces
iw dev wlan0 interface add wifi0 type __ap
iw dev wlan1 interface add wifi1 type __ap

#2.4GHz Virtual Access Points for backhaul connection
iw dev wlan0 interface add wifi2 type __ap
ip addr add 169.254.2.1/24 dev wifi2
ifconfig wifi2 mtu 1600

#5GHz Virtual Access Points for backhaul connection
iw dev wlan1 interface add wifi3 type __ap
ip addr add 169.254.3.1/24 dev wifi3
ifconfig wifi3 mtu 1600

#iw dev wlan0 interface add wifi4 type __ap
#iw dev wlan1 interface add wifi5 type __ap

#Setting brlan0 bridge
if [ ! -f /sys/class/net/brlan0 ]
then
    brctl addbr brlan0
    ip link set brlan0 address `cat /sys/class/net/eth1/address`
fi

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

exit 0
