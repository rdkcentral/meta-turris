!/bin/sh

if [ ! -f /nvram/hostapd0.conf ]
then
        cp /etc/hostapd-2G.conf /nvram/hostapd0.conf
        cp /etc/hostapd-5G.conf /nvram/hostapd1.conf
fi

brctl addbr brlan0
exit 0

