#!/bin/sh

wifi_wlan0=`iwconfig wlan0|grep IEEE\ 802.11 | wc -l`
wifi_wlan1=`iwconfig wlan1|grep IEEE\ 802.11 | wc -l`
wifi_wlan2=`iwconfig wlan2|grep IEEE\ 802.11 | wc -l`
wifi_wlan3=`iwconfig wlan3|grep IEEE\ 802.11 | wc -l`

if [ $wifi_wlan0 == "1" ] ; then
        flag=wlan0 
        wlan0=$(iwconfig wlan0|grep IEEE\ 802.11)
elif [ $wifi_wlan1 == "1" ]; then
        flag=wlan1 
        wlan0=$(iwconfig wlan1|grep IEEE\ 802.11)
elif [ $wifi_wlan2 == "1" ]; then 
        flag=wlan2 
        wlan0=$(iwconfig wlan2|grep IEEE\ 802.11)
elif [ $wifi_wlan3 == "1" ]; then 
        flag=wlan3 
        wlan0=$(iwconfig wlan3|grep IEEE\ 802.11) 
fi 

wifi_driver_init=${#wlan0}
check_dual_band=1
if [ $wifi_driver_init != 0 ]; then
	echo "Wifi (single band) driver is initialized"
        while [ $check_dual_band -le 5 ]
        do
           echo "checking for dual band support:$check_dual_band"
	   if [ $flag == "wlan0" ]; then
		wifi_dual_band=1
	   elif [ $flag == "wlan1" ]; then
		wifi_dual_band=1
	   elif [ $flag == "wlan2" ]; then
		wifi_dual_band=1
	   elif [ $flag == "wlan3" ]; then
		wifi_dual_band=1
	   fi 
	   echo "$wifi_dual_band"
           if [ $wifi_dual_band == 1 ]; then
               break
           fi
           check_dual_band=`expr $check_dual_band + 1`
           sleep 1;
        done
	sleep 1;
	touch /tmp/wifi_driver_initialized
else
	echo "Wifi driver is not initialized"
fi
