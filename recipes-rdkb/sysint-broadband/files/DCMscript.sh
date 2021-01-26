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
#

. /etc/include.properties
. /etc/device.properties
source /etc/log_timestamp.sh
source /lib/rdk/getpartnerid.sh
source /lib/rdk/getaccountid.sh
# Enable override only for non prod builds
if [ "$BUILD_TYPE" != "prod" ] && [ -f $PERSISTENT_PATH/dcm.properties ]; then
      . $PERSISTENT_PATH/dcm.properties
else
      . /etc/dcm.properties
fi

if [ -f /lib/rdk/utils.sh ]; then 
   . /lib/rdk/utils.sh
fi

if [ -f /etc/mount-utils/getConfigFile.sh ];then
     . /etc/mount-utils/getConfigFile.sh
fi
SIGN_FILE="/tmp/.signedRequest_$$_`date +'%s'`"
DIRECT_BLOCK_TIME=86400
DIRECT_BLOCK_FILENAME="/tmp/.lastdirectfail_dcm"
TFTP_SERVER_IP=/tmp/tftpip.txt
export PATH=$PATH:/usr/bin:/bin:/usr/local/bin:/sbin:/usr/local/lighttpd/sbin:/usr/local/sbin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/lib

if [ -z $LOG_PATH ]; then
    LOG_PATH="/rdklogs/logs"
fi

if [ -z $PERSISTENT_PATH ]; then
    PERSISTENT_PATH="/nvram"
fi

TELEMETRY_PATH="$PERSISTENT_PATH/.telemetry"
DCMFLAG="/tmp/.DCMSettingsFlag"
DCM_LOG_FILE="$LOG_PATH/dcmscript.log"
TELEMETRY_INOTIFY_FOLDER="/rdklogs/logs/"
TELEMETRY_INOTIFY_EVENT="$TELEMETRY_INOTIFY_FOLDER/eventType.cmd"
DCMRESPONSE="$PERSISTENT_PATH/DCMresponse.txt"
TELEMETRY_TEMP_RESEND_FILE="/rdklogs/logs/.temp_resend.txt"

PEER_COMM_ID="/tmp/elxrretyt.swr"

TELEMETRY_PREVIOUS_LOG_COMPLETE="/tmp/.telemetry_previous_log_done"
TELEMETRY_PREVIOUS_LOG="/tmp/.telemetry_previous_log"
MAX_PREV_LOG_COMPLETE_WAIT=12

IDLE_TIMEOUT=30

# http header
HTTP_HEADERS='Content-Type: application/json'
## RETRY DELAY in secs
RETRY_DELAY=60
## RETRY COUNT
RETRY_COUNT=3

echo_t "Starting execution of DCMscript.sh"

if [ $# -ne 5 ]; then
    echo_t "Argument does not match"
    echo 0 > $DCMFLAG
    exit 1
fi

. $RDK_PATH/utils.sh

echo "`/bin/timestamp` Starting execution of DCMscript.sh" >> $LOG_PATH/dcmscript.log
#---------------------------------
# Initialize Variables
#---------------------------------
# URL
URL=$2
tftp_server=$3
reboot_flag=$4
checkon_reboot=$5
touch $TFTP_SERVER_IP
echo_t "URL: "$URL
echo_t "DCM_TFTP_SERVER: "$tftp_server >> $TFTP_SERVER_IP
echo_t "BOOT_FLAG: "$reboot_flag
echo_t "CHECK_ON_REBOOT: "$checkon_reboot
rm -f $TELEMETRY_TEMP_RESEND_FILE

conn_str="Direct"
first_conn=useDirectRequest
sec_conn=useCodebigRequest
CodebigAvailable=0

 
if [ -f "/tmp/DCMSettings.conf" ]
then
    Check_URL=`grep 'urn:settings:ConfigurationServiceURL' /tmp/DCMSettings.conf | cut -d '=' -f2 | head -n 1`
    if [ -n "$Check_URL" ]
    then
        URL=`grep 'urn:settings:ConfigurationServiceURL' /tmp/DCMSettings.conf | cut -d '=' -f2 | head -n 1`
        #last_char=`echo $URL | sed -e 's/\(^.*\)\(.$\)/\2/'`
        last_char=`echo $URL | awk '$0=$NF' FS=`
        if [ "$last_char" != "?" ]
        then
            URL="$URL?"
        fi
    fi
fi
# File to save curl response 
#FILENAME="$PERSISTENT_PATH/DCMresponse.txt"
TELE_HTTP_CODE="$PERSISTENT_PATH/telemetry_http_code"
# File to save http code
HTTP_CODE="$PERSISTENT_PATH/http_code"
rm -rf $HTTP_CODE
# Cron job file name
current_cron_file="$PERSISTENT_PATH/cron_file.txt"
# Tftpboot Server Ip
echo TFTP_SERVER: $tftp_server >> $LOG_PATH/dcmscript.log
# Timeout value
timeout=30
default_IP=$DEFAULT_IP
upload_protocol='TFTP'
upload_httplink=$HTTP_UPLOAD_LINK

#---------------------------------
# Function declarations
#---------------------------------

## FW version from version.txt 
getFWVersion()
{
    #cat /version.txt | grep ^imagename:PaceX1 | grep -v image
    verStr=`cat /version.txt | grep ^imagename: | cut -d ":" -f 2`
    echo $verStr
}

## Identifies whether it is a VBN or PROD build
getBuildType()
{
   echo $BUILD_TYPE
}

## Get ECM mac address
getECMMacAddress()
{
    address=`getECMMac`
	mac=`echo $address | tr -d ' ' | tr -d '"'`
	echo $mac
}

## Get Receiver Id
getReceiverId()
{
    if [ -f "$PERSISTENT_PATH/www/whitebox/wbdevice.dat" ]
    then
        ReceiverId=`cat $PERSISTENT_PATH/www/whitebox/wbdevice.dat`
        echo "$ReceiverId"
    else
        echo " "
    fi
}

## Get Controller Id
getControllerId()
{
    echo "2504"
}

## Get ChannelMap Id
getChannelMapId()
{
    echo "2345"
}

## Get VOD Id
getVODId()
{
    echo "15660"
}

IsDirectBlocked()
{
    ret=0
    if [ -f $DIRECT_BLOCK_FILENAME ]; then
        modtime=$(($(date +%s) - $(date +%s -r $DIRECT_BLOCK_FILENAME)))
        if [ "$modtime" -le "$DIRECT_BLOCK_TIME" ]; then
            echo "DCM: Last direct failed blocking is still valid, preventing direct" >>  $DCM_LOG_FILE
            ret=1
        else
            echo "DCM: Last direct failed blocking has expired, removing $DIRECT_BLOCK_FILENAME, allowing direct" >> $DCM_LOG_FILE
            rm -f $DIRECT_BLOCK_FILENAME
            ret=0
        fi
    fi
    return $ret
}

# Get the configuration of codebig settings
get_Codebigconfig()
{
   # If GetServiceUrl not available, then only direct connection available and no fallback mechanism
   if [ -f /usr/bin/GetServiceUrl ]; then
      CodebigAvailable=1
   fi

   if [ "$CodebigAvailable" -eq "1" ]; then
       CodeBigEnable=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.CodeBigFirst.Enable | grep true 2>/dev/null`
   fi
   if [ "$CodebigAvailable" -eq "1" ] && [ "x$CodeBigEnable" != "x" ] ; then
      conn_str="Codebig"
      first_conn=useCodebigRequest
      sec_conn=useDirectRequest
   fi

   if [ "$CodebigAvailable" -eq 1 ]; then
      echo_t "Xconf dcm : Using $conn_str connection as the Primary" >> $DCM_LOG_FILE
   else
      echo_t "Xconf dcm : Only $conn_str connection is available" >> $DCM_LOG_FILE
   fi
}

# Direct connection Download function
useDirectRequest()
{
    # Direct connection will not be tried if .lastdirectfail exists
    IsDirectBlocked
    if [ "$?" -eq "1" ]; then
       return 1
    fi
   count=0
   while [ "$count" -lt "$RETRY_COUNT" ] ; do    
      echo_t " DCM connection type DIRECT"
      CURL_CMD="curl -w '%{http_code}\n' --tlsv1.2 --interface $EROUTER_INTERFACE $addr_type --connect-timeout $timeout -m $timeout -o  \"$FILENAME\" '$HTTPS_URL$JSONSTR'"
      echo_t "CURL_CMD: $CURL_CMD" >> $DCM_LOG_FILE
      HTTP_CODE=`result= eval $CURL_CMD`
      ret=$?

      sleep 2
      http_code=$(echo "$HTTP_CODE" | awk -F\" '{print $1}' )
      [ "x$http_code" != "x" ] || http_code=0
      echo_t "ret = $ret http_code: $http_code" >> $DCM_LOG_FILE

    # log security failure
      case $ret in
        35|51|53|54|58|59|60|64|66|77|80|82|83|90|91)
           echo_t "DCM Direct Connection Failure Attempt:$count - ret:$ret http_code:$http_code" >> $DCM_LOG_FILE
           ;;
      esac
      if [ $http_code -eq 200 ]; then
           echo_t "Direct connection success - ret:$ret http_code:$http_code" >> $DCM_LOG_FILE
           return 0
      elif [ $http_code -eq 404 ]; then 
           echo "`Timestamp` Direct connection Received HTTP $http_code Response from Xconf Server. Retry logic not needed" >> $DCM_LOG_FILE
           bypass_conn=1
           return 0  # Do not return 1, if retry for next conn type is not to be done
      else 
           if [ "$ret" -eq 0 ]; then
               echo_t "DCM Direct Connection Failure Attempt:$count - ret:$ret http_code:$http_code" >> $DCM_LOG_FILE
           fi 
           rm -rf $DCMRESPONSE
      fi
      count=$((count + 1))
      sleep $RETRY_DELAY
    done
    echo_t "DCM :Retries for Direct connection exceeded " >> $DCM_LOG_FILE
    [ "$CodebigAvailable" -ne "1" ] || [ -f $DIRECT_BLOCK_FILENAME ] || touch $DIRECT_BLOCK_FILENAME
    return 1
}

# Codebig connection Download function        
useCodebigRequest()
{
   # Do not try Codebig if CodebigAvailable != 1 (GetServiceUrl not there)
   if [ "$CodebigAvailable" -eq "0" ] ; then
       echo "DCM : Only direct connection Available" >> $DCM_LOG_FILE
       return 1
   fi
   count=0
   while [ "$count" -lt "$RETRY_COUNT" ] ; do    
      SIGN_CMD="GetServiceUrl 3 \"$JSONSTR\""
      eval $SIGN_CMD > $SIGN_FILE
      CB_SIGNED_REQUEST=`cat $SIGN_FILE`
      rm -f $SIGN_FILE
      CURL_CMD="curl -w '%{http_code}\n' --tlsv1.2 --interface $EROUTER_INTERFACE $addr_type --connect-timeout $timeout -m $timeout -o  \"$FILENAME\" \"$CB_SIGNED_REQUEST\""
      echo_t " DCM connection type CODEBIG at `echo "$CURL_CMD" | sed -ne 's#.*\(https:.*\)?.*#\1#p'`" >> $DCM_LOG_FILE
      echo_t "CURL_CMD: `echo "$CURL_CMD" | sed -ne 's#oauth_consumer_key=.*#<hidden>#p'`" >> $DCM_LOG_FILE
      HTTP_CODE=`result= eval $CURL_CMD`
      curlret=$?
      http_code=$(echo "$HTTP_CODE" | awk -F\" '{print $1}' )
      [ "x$http_code" != "x" ] || http_code=0
      echo_t "ret = $curlret http_code: $http_code" >> $DCM_LOG_FILE

      # log security failure
      case $curlret in
          35|51|53|54|58|59|60|64|66|77|80|82|83|90|91)
             echo_t "DCM Codebig Connection Failure Attempt: $count - ret:$curlret http_code:$http_code" >> $DCM_LOG_FILE
             ;;
        esac
       if [ "$http_code" -eq 200 ]; then
           echo_t "Codebig connection success - ret:$curlret http_code:$http_code" >> $DCM_LOG_FILE
           return 0
       elif [ "$http_code" -eq 404 ]; then
           echo_t "DCM Codebig connection Received HTTP $http_code Response from Xconf Server. Retry logic not needed" >> $DCM_LOG_FILE
           bypass_conn=1
           return 0  # Do not return 1, if retry for next conn type is not to be done
       else 
             if [ "$curlret" -eq 0 ]; then
                echo_t "DCM Codebig Connection Failure Attempt:$count - ret:$curlret http_code:$http_code" >> $DCM_LOG_FILE
             fi
              rm -rf $DCMRESPONSE
       fi
       count=$((count + 1))
       sleep $RETRY_DELAY
    done
    echo_t "Retries for Codebig connection exceeded " >> $DCM_LOG_FILE
    return 1
}

sendHttpRequestToServer()
{
    resp=0
    FILENAME=$1
    URL=$2
    echo "filename--args in sendHttpRequestToServer-------"$FILENAME
    echo "url---args in sendHttpRequestToServer------"$URL

    estbMacAddress=`ifconfig erouter0 | grep HWaddr | cut -c39-55`
    JSONSTR=$estbMacAddress
    CURL_CMD="curl -w "%{http_code}" '$URL?estbMacAddress=$JSONSTR&model=$MODEL_NAME'  -o $DCMRESPONSE >> /tmp/telehttpcode.txt "
    echo "------CURL_CMD:"$CURL_CMD

    # Execute curl command
    result= eval $CURL_CMD > $TELE_HTTP_CODE
    #echo "Processing $FILENAME"
    sleep $timeout
    echo "sleep for :------------------"$timeout
    # Get the http_code
    http_code=$(awk -F\" '{print $1}' /tmp/telehttpcode.txt)
    #start of pokuru
                                                                                                         
if [ "$http_code" != "200" ]; then                                                               
    #Added for retry - START                                                                          
    rm -rf /tmp/telehttpcode.txt             
    rm -rf $DCMRESPONSE                                                          
                                                                                                      
    xconfRetryCount=0                                                                                 
    while [ $xconfRetryCount -lt 2 ]
    do                                                                                                
        echo "Trying to Retry connection with XCONF server..."
                                                                                                              
        CURL_CMD="curl -w "%{http_code}" '$URL?estbMacAddress=$JSONSTR&model=$MODEL_NAME'  -o $DCMRESPONSE >> /tmp/telehttpcode.txt "
                                                                                                              
        result= eval $CURL_CMD                                                                                
                                                                                                              
        http_code_retry=$(awk -F\" '{print $1}' /tmp/telehttpcode.txt)                                  
                                                                                                              
        if [ "$http_code_retry" != "200" ]; then                                                         
            echo "Error in establishing communication with xconf server."                                     
                        if [ $xconfRetryCount -ne 0 ]; then sleep 30; fi                                      
                        rm -f /tmp/telehttpcode.txt                                                          
                        rm -rf $DCMRESPONSE
                                                                      
        else                                                                                               
                        echo "After retries...No error in curl command and curl http code is:"$http_code_retry
                        resp=0
                        break                                                                                      
        fi                                                                                                 
                                                                                                                   
        xconfRetryCount=`expr $xconfRetryCount + 1`                                                                
    done
    echo "xconf retry count is:"$xconfRetryCount
    if [ $xconfRetryCount -eq 2 ]; then
         echo "No xconf comm ,exiting script"
         startdcmEnd=`ps -ef | grep -i "StartDCM.sh" | head -n 1`
         kill -9 $startdcmEnd
         exit 0
    fi
    #Added for retry - END                                                                                         
    #echo "Error from cloud exiting,check in upcoming reboot-------------"                                         
    #exit 0                                                                                                        
else                                                                                                               
      echo "No error in curl command and curl http code is:"$http_code                                        
fi     
    #end of pokuru
    echo "----------ret http_code:"$http_code
    echo "----------ret http_code_retry:"$http_code_retry

    if [ $http_code -ne 200 ] ; then
        if [ $http_code_retry -ne 200 ]; then
           echo "curl HTTP request failed http_code :"$http_code
           echo "curl HTTP request failed http_code_retry :"$http_code_retry
           #pokuru rm -rf /tmp/DCMSettings.conf
	    resp=1
        fi 
    else
        echo "curl HTTP request success. Processing response.."
        resp=0
    fi
    echo "----------res:"$resp
    return $resp
}

dropbearRecovery()
{
   dropbearPid=`ps | grep -i dropbear | grep "$ARM_INTERFACE_IP" | grep -v grep`
   if [ -z "$dropbearPid" ]; then
       echo "Dropbear instance is missing ... Recovering dropbear !!! " >> $DCM_LOG_FILE
       DROPBEAR_PARAMS_1="/tmp/.dropbear/dropcfg1$$"
       DROPBEAR_PARAMS_2="/tmp/.dropbear/dropcfg2$$"
       if [ ! -d '/tmp/.dropbear' ]; then
           echo "wan_ssh.sh: need to create dropbear dir !!! " >> $DCM_LOG_FILE
           mkdir -p /tmp/.dropbear
       fi
       echo "wan_ssh.sh: need to create dropbear files !!! " >> $DCM_LOG_FILE
       getConfigFile $DROPBEAR_PARAMS_1
       getConfigFile $DROPBEAR_PARAMS_2
       dropbear -r $DROPBEAR_PARAMS_1 -r $DROPBEAR_PARAMS_2 -E -s -p $ARM_INTERFACE_IP:22 &
       sleep 2
   fi
   rm -rf /tmp/.dropbear/*
}

# Safe wait for IP acquisition
loop=1
counter=0
while [ $loop -eq 1 ]
do
    estbIp=`ifconfig erouter0 | grep -i inet | cut -d ":" -f2 | cut -d " " -f1`
    if [ "X$estbIp" == "X" ]; then
         echo_t "waiting for IP"
         sleep 2
         let counter++
    else
         echo "got IP in erouter0-------------------"
         loop=0
    fi
done

    ret=1
    if [ "$estbIp" == "$default_IP" ] ; then
	  ret=0
    fi
    if [ $checkon_reboot -eq 1 ]; then
        echo "call sendHttpRequestToServer-------------------"
	sendHttpRequestToServer $DCMRESPONSE $URL
	ret=$?
	echo_t "sendHttpRequestToServer returned "$ret
    else
	ret=0
	echo_t "sendHttpRequestToServer has not executed since the value of 'checkon_reboot' is $checkon_reboot" >> $DCM_LOG_FILE
    fi                

        echo "after sendHttpRequestToServer-----sleep for 5 sec-------------"
    sleep 5


    if [ $ret -ne 0 ]; then
        echo_t "Processing response failed." >> $DCM_LOG_FILE
        rm -rf $FILENAME 
        echo_t "count = $count. Sleeping $RETRY_DELAY seconds ..." >> $DCM_LOG_FILE
        exit 1
    fi

    if [ "x$DCA_MULTI_CORE_SUPPORTED" == "xyes" ]; then
            dropbearRecovery

            isPeriodicFWCheckEnabled=`syscfg get PeriodicFWCheck_Enable`
            if [ "$isPeriodicFirmwareEnabled" == "true" ]; then
               echo "XCONF SCRIPT : Calling XCONF Client firmwareSched for the updated time"
               sh /etc/firmwareSched.sh &
            fi

            isAxb6Device="no"
            if [ "$MODEL_NUM" == "TG3482G" ]; then
               isNvram2Mounted=`grep nvram2 /proc/mounts`
               if [ "$isNvram2Mounted" == "" -a -d "/nvram/logs" ]; then
                  isAxb6Device="yes"
               fi
            fi

            if [ "x$isAxb6Device" == "xno" ]; then
               # wait for telemetry previous log to be copied to atom
               loop=1
               while [ $loop -eq 1 ]
               do
                   if [ ! -f $TELEMETRY_PREVIOUS_LOG ]; then
                        echo_t "waiting for previous log file" >> $DCM_LOG_FILE
                        sleep 10
                   else
                        echo_t "scp previous logs from arm to atom done, so breaking loop" >> $DCM_LOG_FILE
                        loop=0
                   fi
               done

               ### Trigger an inotify event on ATOM 
               echo "Telemetry run for previous log trigger to atom" >> $DCM_LOG_FILE
               GetConfigFile $PEER_COMM_ID
               ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ATOM_INTERFACE_IP "/bin/echo 'xconf_update' > $TELEMETRY_INOTIFY_EVENT" > /dev/null 2>&1
               rm -f $PEER_COMM_ID

            fi

            # wait for telemetry previous log to be completed upto 2 mins . Avoid indefenite loops 
            loop=1
            count=0
            while [ "$loop" = "1" ]
            do
                if [ ! -f $TELEMETRY_PREVIOUS_LOG_COMPLETE ]; then
                     echo_t "waiting for previous log done file" >> $DCM_LOG_FILE
                     sleep 10
                     if [ $count -ge $MAX_PREV_LOG_COMPLETE_WAIT ]; then 
                         echo_t "Max wait for previous log done file reached. Proceeding with new config from xconf " >> $DCM_LOG_FILE
                         loop=0
                     fi
                else
                   echo_t "Telemetry run for previous log done, so breaking loop" >> $DCM_LOG_FILE
                   loop=0
                fi
                count=`expr $count + 1`
            done

            GetConfigFile $PEER_COMM_ID
            scp -i $PEER_COMM_ID $DCMRESPONSE root@$ATOM_INTERFACE_IP:$PERSISTENT_PATH > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                scp -i $PEER_COMM_ID $DCMRESPONSE root@$ATOM_INTERFACE_IP:$PERSISTENT_PATH > /dev/null 2>&1
            fi
            echo "Signal atom to pick the XCONF config data $DCMRESPONSE and schedule telemetry !!! " >> $DCM_LOG_FILE
            ## Trigger an inotify event on ATOM 
            ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ATOM_INTERFACE_IP "/bin/echo 'xconf_update' > $TELEMETRY_INOTIFY_EVENT" > /dev/null 2>&1
            rm -f $PEER_COMM_ID
        else
             echo "opensource platforms----------------------------"
            
			isPeriodicFWCheckEnabled=`syscfg get PeriodicFWCheck_Enable`
  		    if [ "$isPeriodicFirmwareEnabled" == "true" ]; then
			   echo "XCONF SCRIPT : Calling XCONF Client firmwareSched for the updated time"
			   sh /etc/firmwareSched.sh &
			fi
             
            # wait for telemetry previous log to be completed
            loop=1
            count=0
            while [ "$loop" = "1" ]
            do
                 echo "TELEMETRY_PREVIOUS_LOG_COMPLETE--------------"$TELEMETRY_PREVIOUS_LOG_COMPLETE
                if [ ! -f $TELEMETRY_PREVIOUS_LOG_COMPLETE ]; then
                     echo_t "waiting for previous log done file"
                     sleep 10
                     if [ $count -ge $MAX_PREV_LOG_COMPLETE_WAIT ]; then 
                         echo_t "Max wait for previous log done file reached. Proceeding with new config from xconf " 
                         loop=0
                     fi
                else
                   echo_t "Telemetry run for previous log done, so breaking loop"
                   loop=0
                fi
                count=`expr $count + 1`
            done
             echo "before calling dca_utility  start of TELEMETRY LOGIC-----------------"
            sh /lib/rdk/dca_utility.sh 1 &
        fi
