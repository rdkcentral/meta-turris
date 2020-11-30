#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2018 RDK Management
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
. /etc/include.properties
. /etc/device.properties
#. /etc/env_setup.sh

processCheck()
{
   count=`ps | grep $1 | grep -v grep | wc -l`
   if [ $count == 0 ]; then
        echo "1"
   else
        echo "0"
   fi
}


getMacAddress()
{
     ifconfig -a | grep $ESTB_INTERFACE | tr -s ' ' | cut -d ' ' -f5
} 

syncLog()
{
    cWD=`pwd`
    syncPath=`find $TEMP_LOG_PATH -type l -exec ls -l {} \; | cut -d ">" -f2`
    if [ "$syncPath" != "$LOG_PATH" ] && [ -d "$TEMP_LOG_PATH" ]; then
         cd "$TEMP_LOG_PATH"
         for file in `ls *.txt *.log`
         do
            cat $file >> $LOG_PATH/$file
            cat /dev/null > $file
         done
         cd $cWD
    else
         echo "Sync Not needed, Same log folder"
    fi
}

rebootFunc()
{
    if [ -f savepwrstate.sh ]; then
         sh /savepwrstate.sh
         sleep 1
    fi
    sync

    if [ ! -f $PERSISTENT_PATH/.lightsleepKillSwitchEnable ]; then
        syncLog

        if [ -f $TEMP_LOG_PATH/error.log ]; then
	    cat $TEMP_LOG_PATH/error.log >> $PERSISTENT_PATH/www/error.log 
	    cat /dev/null > $TEMP_LOG_PATH/error.log
        fi  

        if [ -f $TEMP_LOG_PATH/.systime ]; then
	    cp $TEMP_LOG_PATH/.systime $PERSISTENT_PATH/
        fi  

        if [ -f $TEMP_LOG_PATH/access.log ]; then
	    cat $TEMP_LOG_PATH/access.log >> $PERSISTENT_PATH/www/access.log 
	    cat /dev/null > $TEMP_LOG_PATH/access.log
        fi  
    fi

    reboot 
}


# Return system uptime in seconds
Uptime()
{
     cat /proc/uptime | awk '{ split($1,a,".");  print a[1]; }'
}


