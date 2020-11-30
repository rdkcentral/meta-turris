#!/bin/sh

####################################################################################
# If not stated otherwise in this file or this component's Licenses.txt file the
# following copyright and licenses apply:
#
#  Copyright 2018 RDK Management
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
##################################################################################

if [ -f /etc/os-release ] || [ -f /etc/device.properties ]; then
	LOG_FOLDER="/rdklogs"
else
	LOG_FOLDER="/var/tmp"
fi

source /lib/rdk/t2Shared_api.sh

. /etc/device.properties

CONSOLEFILE="$LOG_FOLDER/logs/Consolelog.txt.0"

echo_time()
{
	echo "`date +"%y%m%d-%T.%6N"` getPartnerId() called from: $0 -  $1"
}

# Function to get partner_id
getPartnerId()
{
#Get PartnerID set in the system via syscfg get command
partner_id=`syscfg get PartnerID`
syscfg_err=`echo $partner_id | grep -i error`

#Try "dmcli" to retrieve partner_id if "sysconf" returned null. It's a fallback check.
if [ "$partner_id" == "" ] || [ "$syscfg_err" != "" ];then
	partner_id=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_Syndication.PartnerId | grep string | awk '{print $5}'`

	#Check for PartnerID in device.properties if its not set already.
	if [ "$partner_id" == "" ];then
		if [ -f "/etc/device.properties" ];then
# PARTNER_ID is read from etc/device.properties file
			partner_id=`echo $PARTNER_ID`
				if [ "$partner_id" == "" ];then
					echo_time "partner_id is not available from syscfg.db or tr181 param or device.properties, defaulting to comcast..">>$CONSOLEFILE
					t2CountNotify "SYS_ERROR_PartnerId_missing_sycfg"
					echo "comcast"
				else
					echo_time "partner_id is not available from syscfg.db or tr181 param, value retrieved from device.properties : $partner_id">>$CONSOLEFILE
					echo "$partner_id"
				fi
		else
			echo_time "partner_id is not available, defaulting to comcast.">>$CONSOLEFILE
			echo "comcast"
		fi
	else
		echo_time "partner_id is not available from syscfg.db, value retrieved from tr181 param : $partner_id">>$CONSOLEFILE
		echo "$partner_id"
	fi
else
	echo_time "partner_id retrieved from syscfg.db : $partner_id">>$CONSOLEFILE
	echo "$partner_id"
fi
}

getExperience()
{
    echo ""
}

case=$1
if [ "$case" = "GetPartnerID" ]; then
    getPartnerId
fi

