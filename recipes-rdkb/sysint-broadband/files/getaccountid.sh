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

KEY_LEN="32"
CONSOLEFILE="$LOG_FOLDER/logs/Consolelog.txt.0"

echo_time()
{
        echo "`date +"%y%m%d-%T.%6N"` getAccountId() called from: $0 -  $1"
}


check_accountid()
{
accountId="$1"
accountIdlen="$(echo ${#accountId})"
checkisalnum=`echo $accountId | grep -E '^[-_0-9a-zA-Z]*$'`

if [ "$accountIdlen" -lt "$KEY_LEN" ] && [[ "$checkisalnum" != "" ]] && [[ "$accountId" != "*['!'@'#'"$"%^&*()+]*" ]];  then
     echo_time "accountId is valid and value retrieved from tr181/webpa param..." >>$CONSOLEFILE
     echo "$accountId"
else
     echo_time "accountId is invalid as contains specail characters or larger than max $KEY_LEN characters..." >>$CONSOLEFILE
     echo "Unknown"
fi

}

# Function to get account_id
getAccountId()
{

#Get AccountID set in the system via syscfg get command
accountId=`syscfg get AccountID`

#Try "dmcli" to retrieve accountId if "sysconf" returned null. It's a fallback check.
if [ "$accountId" == "" ];then
      accountId=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.AccountInfo.AccountID | grep string | awk '{print $5}'`

      if [ "$accountId" == "" ]; then
           echo_time "account_id is not available from syscfg.db or tr181 param, defaulting to Unknown...">>$CONSOLEFILE
           echo "Unknown"
      else
           echo_time "Checking accountId is alphanumeric and not greater than $KEY_LEN characters...">>$CONSOLEFILE
           check_accountid $accountId
      fi

else
        echo_time "Checking accountId is alphanumeric and not greater than $KEY_LEN characters...">>$CONSOLEFILE
        check_accountid $accountId
fi
}

