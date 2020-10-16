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
if [ -b /dev/mmcblk0p6 ]; then
	#for Older Turris Omnia
	mount /dev/mmcblk0p6 /nvram
else
	#for Omnia2019 and  Omnia2020
	mount /dev/mmcblk0p5 /nvram
fi

WIFI0_MAC=`cat /sys/class/net/wlan0/address`
WIFI1_MAC=`cat /sys/class/net/wlan1/address`
echo "2.4GHz Radio MAC: $WIFI0_MAC"
echo "5GHz   Radio MAC: $WIFI1_MAC"

if [ ! -f /nvram/hostapd0.conf ]
then
	cp /etc/hostapd-2G.conf /nvram/hostapd0.conf
	#Set bssid for wifi0
        NEW_MAC=$(echo 0x$WIFI0_MAC| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+2, $2, $3, $4 ,$5, $6}')
	sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd0.conf
fi

if [ ! -f /nvram/hostapd1.conf ]
then
	cp /etc/hostapd-5G.conf /nvram/hostapd1.conf
	#Set bssid for wifi1
        NEW_MAC=$(echo 0x$WIFI1_MAC| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+2, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd1.conf
fi

if [ ! -f /nvram/hostapd2.conf ]
then
	cp /etc/hostapd-bhaul2G.conf /nvram/hostapd2.conf
	#Set bssid for wifi2
        NEW_MAC=$(echo 0x$WIFI0_MAC| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+4, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd2.conf
fi

if [ ! -f /nvram/hostapd3.conf ]
then
	cp /etc/hostapd-bhaul5G.conf /nvram/hostapd3.conf
	#Set bssid for wifi3
        NEW_MAC=$(echo 0x$WIFI1_MAC| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+4, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd3.conf
fi

if [ ! -f /nvram/hostapd4.conf ]
then
	cp /etc/hostapd-bhaul2G.conf /nvram/hostapd4.conf
	#Set bssid for wifi4
        NEW_MAC=$(echo 0x$WIFI0_MAC| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+6, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd4.conf
        sed -i "/^interface=/c\interface=wifi4" /nvram/hostapd4.conf
fi

if [ ! -f /nvram/hostapd5.conf ]
then
	cp /etc/hostapd-bhaul5G.conf /nvram/hostapd5.conf
	#Set bssid for wifi5
        NEW_MAC=$(echo 0x$WIFI1_MAC| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+6, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd5.conf
        sed -i "/^interface=/c\interface=wifi5" /nvram/hostapd5.conf
fi

#Setting up VAP status file
echo -e "wifi0=1\nwifi1=1\nwifi2=0\nwifi3=0\nwifi4=0\nwifi5=0" >/tmp/vap-status

#Creating files for tracking AssociatedDevices
touch /tmp/AllAssociated_Devices_2G.txt
touch /tmp/AllAssociated_Devices_5G.txt

if [ $device_type == "extender" ];
then
        exit 0;
fi

#Creating wifi0 and wifi1 AP interfaces
iw dev wlan0 interface add wifi0 type __ap
iw dev wlan1 interface add wifi1 type __ap

#2.4GHz Virtual Access Points for backhaul connection
iw dev wlan0 interface add wifi2 type __ap
ip addr add 169.254.0.1/24 dev wifi2
ifconfig wifi2 mtu 1600

#5GHz Virtual Access Points for backhaul connection
iw dev wlan1 interface add wifi3 type __ap
ip addr add 169.254.1.1/24 dev wifi3
ifconfig wifi3 mtu 1600

#2.4GHz Virtual Access Points for onboard connection
iw dev wlan0 interface add wifi4 type __ap
ip addr add 169.254.0.1/24 dev wifi4
ifconfig wifi2 mtu 1600

#5GHz Virtual Access Points for onboard connection
iw dev wlan1 interface add wifi5 type __ap
ip addr add 169.254.1.1/24 dev wifi5
ifconfig wifi3 mtu 1600

#iw dev wlan0 interface add wifi4 type __ap
#iw dev wlan1 interface add wifi5 type __ap

#Create empty acl list for hostapd
touch /tmp/hostapd-acl0
touch /tmp/hostapd-acl1
touch /tmp/hostapd-acl2
touch /tmp/hostapd-acl3
touch /tmp/hostapd-acl4
touch /tmp/hostapd-acl5

#create empty psk files
touch /tmp/hostapd0.psk
touch /tmp/hostapd1.psk
touch /tmp/hostapd2.psk
touch /tmp/hostapd3.psk
touch /tmp/hostapd4.psk
touch /tmp/hostapd5.psk

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
