#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2016 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################
# Scripts having common utility functions

if [ -f /etc/utopia/service.d/log_env_var.sh ];then
	source /etc/utopia/service.d/log_env_var.sh
fi

CMINTERFACE="wan0"
WANINTERFACE="erouter0"

#checkProcess()
#{
#  ps -ef | grep $1 | grep -v grep
#}

Timestamp()
{
	    date +"%Y-%m-%d %T"
}

# Set the name of the log file using SHA1
#setLogFile()
#{
#    fileName=`basename $6`
#    echo $1"_mac"$2"_dat"$3"_box"$4"_mod"$5"_"$fileName
#}

# Get the MAC address of the machine
getMacAddressOnly()
{
     mac=`ifconfig $WANINTERFACE | grep HWaddr | cut -d " " -f7 | sed 's/://g'`
     echo $mac
}

# Get the SHA1 checksum
getSHA1()
{
    sha1sum $1 | cut -f1 -d" "

}

# IP address of the machine
getIPAddress()
{
    wanIP=`ifconfig $WANINTERFACE | grep "inet addr" | grep -v inet6 | cut -f2 -d: | cut -f1 -d" "`
    echo $wanIP
}

getCMIPAddress()
{
    if [ "$BOX_TYPE" = "XB6" ] || [ "$BOX_TYPE" = "TCCBR" ]; then
       address=`dmcli eRT getv Device.X_CISCO_COM_CableModem.IPv6Address | grep string | awk '{print $5}'`
       if [ ! "$address" ]; then
          address=`dmcli eRT getv Device.X_CISCO_COM_CableModem.IPAddress | grep string | awk '{print $5}'`
       fi
    elif [ $BOX_TYPE = "XF3" ] || [ "$BOX_TYPE" = "HUB4" ]; then
       # in PON/DSL you cant get the CM IP address, so use eRouter IP address
       address=`ifconfig $WANINTERFACE | grep "inet addr" | grep -v inet6 | cut -f2 -d: | cut -f1 -d" "` 
    else                           
       address=`ifconfig -a $CMINTERFACE | grep inet6 | tr -s " " | grep -v Link | cut -d " " -f4 | cut -d "/" -f1`
       if [ ! "$address" ]; then
          address=`ifconfig -a $CMINTERFACE | grep inet | grep -v inet6 | tr -s " " | cut -d ":" -f2 | cut -d " " -f1`
       fi
    fi
    echo $address

}

getErouterIPAddress()
{
    if [ "$BOX_TYPE" = "XB6" ] || [ "$BOX_TYPE" = "TCCBR" ]; then
        address=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_IPv6 | grep string | awk '{print $5}'`
        if [ ! "$address" ]; then
            address=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_IP | grep string | awk '{print $5}'`
        fi
    elif [ $BOX_TYPE = "XF3" ] || [ "$BOX_TYPE" = "HUB4" ]; then
       # in PON/DSL you cant get the CM IP address, so use eRouter IP address
       address=`ifconfig $WANINTERFACE | grep "inet addr" | grep -v inet6 | cut -f2 -d: | cut -f1 -d" "`
    else
       address=`ifconfig -a $WANINTERFACE | grep inet6 | tr -s " " | grep -v Link | cut -d " " -f4 | cut -d "/" -f1`
       if [ ! "$address" ]; then
          address=`ifconfig -a $WANINTERFACE | grep inet | grep -v inet6 | tr -s " " | cut -d ":" -f2 | cut -d " " -f1`
       fi
    fi
    echo $address
}

processCheck()
{
   ps -ef | grep $1 | grep -v grep > /dev/null 2>/dev/null 
   if [ $? -ne 0 ]; then
         echo "1"
   else
         echo "0"
   fi
}

getMacAddress()
{
    if [ $BOX_TYPE = "XF3" ]; then                           
        mac=`dmcli eRT getv Device.DPoE.Mac_address | grep value | awk '{print $5}'`
    elif [ "$BOX_TYPE" = "XB6" ] || [ "$BOX_TYPE" = "TCCBR" ];then
        mac=`dmcli eRT getv Device.X_CISCO_COM_CableModem.MACAddress | grep value | awk '{print $5}'`
    elif [ "$BOX_TYPE" = "XF3" ]; then
       mac=`ifconfig $WANINTERFACE | grep HWaddr | cut -d " " -f7`
    else                                                           
       mac=`ifconfig $WANINTERFACE | grep HWaddr | cut -d " " -f7`
    fi
    echo $mac
}

## Get eSTB mac address 
getErouterMacAddress()
{
    erouterMac=`ifconfig $WANINTERFACE | grep HWaddr | cut -d " " -f7`
    echo $erouterMac
}

rebootFunc()
{
    #sync
    reboot
}

# Return system uptime in seconds
Uptime()
{
     cat /proc/uptime | awk '{ split($1,a,".");  print a[1]; }'
}

## Get Model No of the box
getModel()
{
  if [ $BOX_TYPE = "XF3" ]; then
     modelName=`grep ^imagename: /fss/gw/version.txt | cut -d ":" -f 2 | cut -d "_" -f 1`
  else
     modelName=`dmcli eRT getv Device.DeviceInfo.ModelName | grep value | awk '{print $5}'`
     if [ "$modelName" = "" ]
     then
            modelName=`echo $MODEL_NUM`
     fi
  fi
  echo "$modelName"
}

getFWVersion()
{
    # Handle imagename separator being colon or equals
    grep imagename /version.txt | sed 's/.*[:=]//'
}

getBuildType()
{
    str=$(getFWVersion)

    echo $str | grep -q 'VBN'
    if [[ $? -eq 0 ]] ; then
        echo 'vbn'
    else
        echo $str | grep -q 'PROD'
        if [[ $? -eq 0 ]] ; then
            echo 'prod'
        else
            echo $str | grep -q 'QA'
            if [[ $? -eq 0 ]] ; then
                echo 'qa'
            else
                echo 'dev'
            fi
        fi
    fi
}


