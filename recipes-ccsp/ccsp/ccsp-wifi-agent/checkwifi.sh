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

wifi_wifi0=`iwconfig wifi0|grep IEEE\ 802.11 | wc -l`
wifi_wifi1=`iwconfig wifi1|grep IEEE\ 802.11 | wc -l`
wifi_wifi2=`iwconfig wifi2|grep IEEE\ 802.11 | wc -l`
wifi_wifi3=`iwconfig wifi3|grep IEEE\ 802.11 | wc -l`

if [ $wifi_wifi0 == "1" ] ; then
        flag=wifi0 
        wifi0=$(iwconfig wifi0|grep IEEE\ 802.11)
elif [ $wifi_wifi1 == "1" ]; then
        flag=wifi1 
        wifi0=$(iwconfig wifi1|grep IEEE\ 802.11)
elif [ $wifi_wifi2 == "1" ]; then 
        flag=wifi2 
        wifi0=$(iwconfig wifi2|grep IEEE\ 802.11)
elif [ $wifi_wifi3 == "1" ]; then 
        flag=wifi3 
        wifi0=$(iwconfig wifi3|grep IEEE\ 802.11) 
fi 

wifi_driver_init=${#wifi0}
check_dual_band=1
if [ $wifi_driver_init != 0 ]; then
	echo "Wifi (single band) driver is initialized"
        while [ $check_dual_band -le 5 ]
        do
           echo "checking for dual band support:$check_dual_band"
	   if [ $flag == "wifi0" ]; then
		wifi_dual_band=1
	   elif [ $flag == "wifi1" ]; then
		wifi_dual_band=1
	   elif [ $flag == "wifi2" ]; then
		wifi_dual_band=1
	   elif [ $flag == "wifi3" ]; then
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
