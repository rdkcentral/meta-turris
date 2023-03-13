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
modprobe ip_gre
#Workaround: allowing devices initialization
sleep 5;
fi

nvram_mounted=`mount | grep nvram -wc`
if [ $nvram_mounted == 0 ]; then
	mkdir -p /nvram
	if [ -b /dev/mmcblk0p6 ]; then
		#for Older Turris Omnia
		mount /dev/mmcblk0p6 /nvram
	else
		#for Omnia2019 and  Omnia2020
		mount /dev/mmcblk0p5 /nvram
	fi
fi

WLAN24G="wlan0"
WLAN5G="wlan1"
WLAN6G="wlan2"

iw dev del ${WLAN24G}
iw dev del ${WLAN5G}
iw dev del ${WLAN6G}

PHY_CAPABILITIES=$(iw phy | grep -E "Wiphy|Band" | awk 'BEGIN{RS="Wiphy "} {print $0}' | tr -d ' \t\n:' | sed 's/phy/\n&/g' | grep phy | awk '{ print length(), $0 | "sort -n" }' | awk '{$1=""; print $0}')
WLAN_SET=(0 0 0)

for PHY in $PHY_CAPABILITIES; do
    PHY_HAS_24G=$(echo "$PHY" | grep "Band1")
    PHY_HAS_5G=$(echo "$PHY" | grep "Band2")
    PHY_HAS_6G=$(echo "$PHY" | grep "Band4")
    PHY=$(echo "$PHY" | grep -oE "phy[0-9]+")

    if [ -n "${PHY_HAS_6G}" ] && ! $WLAN_SET[2]; then
        iw phy $PHY interface add ${WLAN6G} type managed
        $WLAN_SET[2]=1
    elif [ -n "${PHY_HAS_5G}" ] && ! $WLAN_SET[1]; then
        iw phy $PHY interface add ${WLAN5G} type managed
        $WLAN_SET[1]=1
    elif [ -n "${PHY_HAS_24G}" ] && ! $WLAN_SET[0]; then
        iw phy $PHY interface add ${WLAN24G} type managed
        $WLAN_SET[0]=1
    else
        echo "No valid capabilities detected!"
        exit 1
    fi
done

WIFI24G_MAC=`cat "/sys/class/net/${WLAN24G}/address"`
WIFI5G_MAC=`cat "/sys/class/net/${WLAN5G}/address"`
WIFI6G_MAC=`cat "/sys/class/net/${WLAN6G}/address"`

echo "2.4GHz Radio MAC: ${WIFI24G_MAC}"
echo "5GHz   Radio MAC: ${WIFI5G_MAC}"
echo "6GHz   Radio MAC: ${WIFI6G_MAC}"

if [ ! -f /nvram/hostapd0.conf ]
then
	cp /etc/hostapd-2G.conf /nvram/hostapd0.conf
	#Set bssid for wifi0
        NEW_MAC=$(echo 0x${WIFI24G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+2, $2, $3, $4 ,$5, $6}')
	sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd0.conf
        echo "wpa_psk_file=/tmp/hostapd0.psk" >> /nvram/hostapd0.conf
fi

if [ ! -f /nvram/hostapd1.conf ]
then
	cp /etc/hostapd-5G.conf /nvram/hostapd1.conf
	#Set bssid for wifi1
        NEW_MAC=$(echo 0x${WIFI5G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+2, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd1.conf
        echo "wpa_psk_file=/tmp/hostapd1.psk" >> /nvram/hostapd1.conf
fi

if [ ! -f /nvram/hostapd2.conf ]
then
	cp /etc/hostapd-bhaul2G.conf /nvram/hostapd2.conf
	#Set bssid for wifi2
        NEW_MAC=$(echo 0x${WIFI24G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+4, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd2.conf
        echo "wpa_psk_file=/tmp/hostapd2.psk" >> /nvram/hostapd2.conf
fi

if [ ! -f /nvram/hostapd3.conf ]
then
	cp /etc/hostapd-bhaul5G.conf /nvram/hostapd3.conf
	#Set bssid for wifi3
        NEW_MAC=$(echo 0x${WIFI5G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+4, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd3.conf
        echo "wpa_psk_file=/tmp/hostapd3.psk" >> /nvram/hostapd3.conf
fi

if [ ! -f /nvram/hostapd4.conf ]
then
	cp /etc/hostapd-2G.conf /nvram/hostapd4.conf
	#Set bssid for wifi4
        NEW_MAC=$(echo 0x${WIFI24G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+6, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd4.conf
        sed -i "/^interface=/c\interface=wifi4" /nvram/hostapd4.conf
        sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl4"  /nvram/hostapd4.conf
        echo "wpa_psk_file=/tmp/hostapd4.psk" >> /nvram/hostapd4.conf
fi

if [ ! -f /nvram/hostapd5.conf ]
then
	cp /etc/hostapd-5G.conf /nvram/hostapd5.conf
	#Set bssid for wifi5
        NEW_MAC=$(echo 0x${WIFI5G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+6, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd5.conf
        sed -i "/^interface=/c\interface=wifi5" /nvram/hostapd5.conf
        sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl5" /nvram/hostapd5.conf
        echo "wpa_psk_file=/tmp/hostapd5.psk" >> /nvram/hostapd5.conf
fi

if [ ! -f /nvram/hostapd6.conf ]
then
	cp /etc/hostapd-2G.conf /nvram/hostapd6.conf
	#Set bssid for wifi6
        NEW_MAC=$(echo 0x${WIFI24G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+8, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd6.conf
        sed -i "/^interface=/c\interface=wifi6" /nvram/hostapd6.conf
        sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl6"  /nvram/hostapd6.conf
        echo "wpa_psk_file=/tmp/hostapd6.psk" >> /nvram/hostapd6.conf
fi

if [ ! -f /nvram/hostapd7.conf ]
then
	cp /etc/hostapd-5G.conf /nvram/hostapd7.conf
	#Set bssid for wifi7
        NEW_MAC=$(echo 0x${WIFI5G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+8, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd7.conf
        sed -i "/^interface=/c\interface=wifi7" /nvram/hostapd7.conf
        sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl7"  /nvram/hostapd7.conf
        echo "wpa_psk_file=/tmp/hostapd7.psk" >> /nvram/hostapd7.conf
fi

if [ ! -f /nvram/hostapd8.conf ]
then
	cp /etc/hostapd-open2G.conf /nvram/hostapd8.conf
	#Set bssid for wifi8
        NEW_MAC=$(echo 0x${WIFI24G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+12, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd8.conf
        sed -i "/^interface=/c\interface=wifi8" /nvram/hostapd8.conf
        sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl8"  /nvram/hostapd8.conf
fi

if [ ! -f /nvram/hostapd9.conf ]
then
	cp /etc/hostapd-open5G.conf /nvram/hostapd9.conf
	#Set bssid for wifi9
        NEW_MAC=$(echo 0x${WIFI5G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+12, $2, $3, $4 ,$5, $6}')
        sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd9.conf
        sed -i "/^interface=/c\interface=wifi9" /nvram/hostapd9.conf
        sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl9"  /nvram/hostapd9.conf
fi

#Setting up VAP status file
echo -e "wifi0=1\nwifi1=1\nwifi2=0\nwifi3=0\nwifi4=0\nwifi5=0\nwifi6=0\nwifi7=0\nwifi8=0\nwifi9=0" >/tmp/vap-status

#Creating files for tracking AssociatedDevices
touch /tmp/AllAssociated_Devices_2G.txt
touch /tmp/AllAssociated_Devices_5G.txt

if [ $device_type == "extender" ];
then
        ifconfig ${WLAN6G} down
        ifconfig ${WLAN5G} down
        ifconfig ${WLAN24G} down
        exit 0;
fi

#Creating virtual interfaces wifi0 and wifi1 for Home APs
iw dev ${WLAN24G} interface add wifi0 type __ap
iw dev ${WLAN5G} interface add wifi1 type __ap

#2.4GHz Virtual Access Points for backhaul connection
iw dev ${WLAN24G} interface add wifi2 type __ap
ip addr add 169.254.0.1/25 dev wifi2
ifconfig wifi2 mtu 1600

#5GHz Virtual Access Points for backhaul connection
iw dev ${WLAN5G} interface add wifi3 type __ap
ip addr add 169.254.1.1/25 dev wifi3
ifconfig wifi3 mtu 1600

#Creating virtual interfaces wifi4 and wifi5 for Guest APs
iw dev ${WLAN24G} interface add wifi4 type __ap
iw dev ${WLAN5G} interface add wifi5 type __ap

#2.4GHz Virtual Access Points for Secure Onboard connection
iw dev ${WLAN24G} interface add wifi6 type __ap
ip addr add 169.254.0.129/25 dev wifi6
ifconfig wifi6 mtu 1600

#5GHz Virtual Access Points for onboard connection
iw dev ${WLAN5G} interface add wifi7 type __ap
ip addr add 169.254.1.129/25 dev wifi7
ifconfig wifi7 mtu 1600

#Creating virtual interfaces wifi8 and wifi9 for Service APs
iw dev ${WLAN24G} interface add wifi8 type __ap
iw dev ${WLAN5G} interface add wifi9 type __ap

#update mac from hostapd config
for i in $(echo "{0..9}"); do
        ifconfig wifi$i hw ether $(cat /nvram/hostapd${i}.conf |grep bssid | cut -d = -f 2)
done

#Create empty acl list for hostapd
touch /tmp/hostapd-acl0
touch /tmp/hostapd-acl1
touch /tmp/hostapd-acl2
touch /tmp/hostapd-acl3
touch /tmp/hostapd-acl4
touch /tmp/hostapd-acl5
touch /tmp/hostapd-acl6
touch /tmp/hostapd-acl7
touch /tmp/hostapd-acl8
touch /tmp/hostapd-acl9

#create empty psk files
touch /tmp/hostapd0.psk
touch /tmp/hostapd1.psk
touch /tmp/hostapd2.psk
touch /tmp/hostapd3.psk
touch /tmp/hostapd6.psk
touch /tmp/hostapd7.psk
touch /tmp/hostapd8.psk
touch /tmp/hostapd9.psk

#6GHz configs
if [ -n $WIFI_6G_MAC ]
then
    if [ ! -f /nvram/hostapd10.conf ]
    then
        cp /etc/hostapd-6G.conf /nvram/hostapd10.conf
        #Set bssid for wifi10
            NEW_MAC=$(echo 0x${WIFI6G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+2, $2, $3, $4 ,$5, $6}')
            sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd10.conf
            echo "wpa_psk_file=/tmp/hostapd10.psk" >> /nvram/hostapd10.conf
    fi

    if [ ! -f /nvram/hostapd11.conf ]
    then
        cp /etc/hostapd-bhaul6G.conf /nvram/hostapd11.conf
        #Set bssid for wifi11
            NEW_MAC=$(echo 0x${WIFI6G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+4, $2, $3, $4 ,$5, $6}')
            sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd11.conf
            echo "wpa_psk_file=/tmp/hostapd11.psk" >> /nvram/hostapd11.conf
    fi

    if [ ! -f /nvram/hostapd12.conf ]
    then
        cp /etc/hostapd-6G.conf /nvram/hostapd12.conf
        #Set bssid for wifi12
            NEW_MAC=$(echo 0x${WIFI6G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+6, $2, $3, $4 ,$5, $6}')
            sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd12.conf
            sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl12"  /nvram/hostapd12.conf
            echo "wpa_psk_file=/tmp/hostapd12.psk" >> /nvram/hostapd12.conf
    fi

    if [ ! -f /nvram/hostapd13.conf ]
    then
        cp /etc/hostapd-6G.conf /nvram/hostapd13.conf
        #Set bssid for wifi13
            NEW_MAC=$(echo 0x${WIFI6G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+8, $2, $3, $4 ,$5, $6}')
            sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd13.conf
            sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl13"  /nvram/hostapd13.conf
            echo "wpa_psk_file=/tmp/hostapd13.psk" >> /nvram/hostapd13.conf
    fi

    if [ ! -f /nvram/hostapd14.conf ]
    then
        cp /etc/hostapd-6G.conf /nvram/hostapd14.conf
        #Set bssid for wifi14
            NEW_MAC=$(echo 0x${WIFI6G_MAC}| awk -F: '{printf "%02x:%s:%s:%s:%s:%s", strtonum($1)+12, $2, $3, $4 ,$5, $6}')
            sed -i "/^bssid=/c\bssid=$NEW_MAC" /nvram/hostapd14.conf
            sed -i "/^accept_mac/c\accept_mac_file=/tmp/hostapd-acl14"  /nvram/hostapd14.conf
    fi

    echo -e "wifi10=1\nwifi11=0\nwifi12=0\nwifi13=0\nwifi14=0" >> /tmp/vap-status
    touch /tmp/AllAssociated_Devices_6G.txt

    iw dev ${WLAN6G} interface add wifi10 type __ap
    iw dev ${WLAN6G} interface add wifi11 type __ap
    ip addr add 169.254.2.1/24 dev wifi11
    ifconfig wifi11 mtu 1600
    iw dev ${WLAN6G} interface add wifi12 type __ap
    iw dev ${WLAN6G} interface add wifi13 type __ap
    iw dev ${WLAN6G} interface add wifi14 type __ap

    for i in $(echo "{10..14}"); do
        ifconfig wifi$i hw ether $(cat /nvram/hostapd${i}.conf |grep bssid | cut -d = -f 2)
    done

    touch /tmp/hostapd-acl10
    touch /tmp/hostapd-acl11
    touch /tmp/hostapd-acl12
    touch /tmp/hostapd-acl13
    touch /tmp/hostapd-acl14

    touch /tmp/hostapd10.psk
    touch /tmp/hostapd11.psk
    touch /tmp/hostapd12.psk
    touch /tmp/hostapd13.psk
    touch /tmp/hostapd14.psk
fi

#Create wps pin request log file
touch /var/run/hostapd_wps_pin_requests.log

#Setting brlan0 bridge
if [ ! -f /sys/class/net/brlan0 ]
then
    brctl addbr brlan0
    ip link set brlan0 address `cat /sys/class/net/eth1/address`
    ifconfig brlan0 `syscfg get lan_ipaddr` netmask `syscfg get lan_netmask` up
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
