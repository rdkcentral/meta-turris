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


####
## This script will be invoked upon receiving events from ATOM when processed telemetry dat is available for upload
## This cript is expected to pull the 
####

. /etc/include.properties
. /etc/device.properties

if [ -f /lib/rdk/utils.sh  ]; then
   . /lib/rdk/utils.sh
fi
source /etc/log_timestamp.sh
TELEMETRY_PATH="$PERSISTENT_PATH/.telemetry"
TELEMETRY_RESEND_FILE="$PERSISTENT_PATH/.resend.txt"
TELEMETRY_TEMP_RESEND_FILE="$PERSISTENT_PATH/.temp_resend.txt"

TELEMETRY_PROFILE_DEFAULT_PATH="/tmp/DCMSettings.conf"
TELEMETRY_PROFILE_RESEND_PATH="$PERSISTENT_PATH/.DCMSettings.conf"
TELEMETRY_TFTP_UPLOAD_JSON_FILE="$PERSISTENT_PATH/tftp_json.txt"

RTL_LOG_FILE="$LOG_PATH/dcmscript.log"

HTTP_FILENAME="$TELEMETRY_PATH/dca_httpresult.txt"

DCMRESPONSE="$PERSISTENT_PATH/DCMresponse.txt"

PEER_COMM_ID="/tmp/elxrretyt.swr"

#pokuru if [ ! -f /usr/bin/GetConfigFile ];then
    #pokuru echo "Error: GetConfigFile Not Found"
    #pokuru exit 127
#pokuru fi

SIGN_FILE="/tmp/.signedRequest_$$_`date +'%s'`"
DIRECT_BLOCK_TIME=86400
DIRECT_BLOCK_FILENAME="/tmp/.lastdirectfail_dca"

SLEEP_TIME_FILE="/tmp/.rtl_sleep_time.txt"
#MAX_LIMIT_RESEND=2
# Max backlog queue set to 5, after which the resend file will discard subsequent entries
MAX_CONN_QUEUE=5
DIRECT_RETRY_COUNT=2

ignoreResendList="false"

# exit if an instance is already running
if [ ! -f /tmp/.dca-splunk.upload ];then
    # store the PID
    echo $$ > /tmp/.dca-splunk.upload
else
    pid=`cat /tmp/.dca-splunk.upload`
    if [ -d /proc/$pid ];then
         echo_t "dca : previous instance of dcaSplunkUpload.sh is running."
         ignoreResendList="true"
         # Cannot exit as triggers can be from immediate log upload
    else
        rm -f /tmp/.dca-splunk.upload
        echo $$ > /tmp/.dca-splunk.upload
    fi
fi

conn_type_used=""   # Use this to check the connection success, else set to fail
conn_type="Direct" # Use this to check the connection success, else set to fail
first_conn=useDirectRequest
sec_conn=useCodebigRequest
CodebigAvailable=0

CURL_TIMEOUT=30
TLS="--tlsv1.2" 

mkdir -p $TELEMETRY_PATH

# Processing Input Args
inputArgs=$1

# dca_utility.sh does  not uses TELEMETRY_PROFILE_RESEND_PATH, to hardwired to TELEMETRY_PROFILE_DEFAULT_PATH
[ "x$sendInformation" != "x"  ] || sendInformation=1
if [ "$sendInformation" -ne 1 ] ; then
   TELEMETRY_PROFILE_PATH=$TELEMETRY_PROFILE_RESEND_PATH
else
   TELEMETRY_PROFILE_PATH=$TELEMETRY_PROFILE_DEFAULT_PATH
fi
	
echo "Telemetry Profile File Being Used : $TELEMETRY_PROFILE_PATH" >> $RTL_LOG_FILE
	
#Adding support for opt override for dcm.properties file
if [ "$BUILD_TYPE" != "prod" ] && [ -f $PERSISTENT_PATH/dcm.properties ]; then
      . $PERSISTENT_PATH/dcm.properties
else
      . /etc/dcm.properties
fi
TelemetryNewEndpointAvailable=0
getTelemetryEndpoint() {
    DEFAULT_DCA_UPLOAD_URL="$DCA_UPLOAD_URL"
    TelemetryEndpoint=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.TelemetryEndpoint.Enable  | grep value | awk '{print $5}'`
    TelemetryEndpointURL=""
    if [ "x$TelemetryEndpoint" = "xtrue" ]; then
        TelemetryEndpointURL=`dmcli eRT getv Device.DeviceInfo.X_RDKCENTRAL-COM_RFC.Feature.TelemetryEndpoint.URL  | grep value | awk '{print $5}'`
        if [ ! -z "$TelemetryEndpointURL" ]; then
            DCA_UPLOAD_URL="https://$TelemetryEndpointURL"
            echo_t "dca upload url from RFC is $TelemetryEndpointURL" >> $RTL_LOG_FILE
            TelemetryNewEndpointAvailable=1
        fi
    else
        if [ -f "$DCMRESPONSE" ]; then    
            TelemetryEndpointURL=`grep '"uploadRepository:URL":"' $DCMRESPONSE | awk -F 'uploadRepository:URL":' '{print $NF}' | awk -F '",' '{print $1}' | sed 's/"//g' | sed 's/}//g'`
        
            if [ ! -z "$TelemetryEndpointURL" ]; then	    
            	DCA_UPLOAD_URL="$TelemetryEndpointURL"
            	echo_t "dca upload url from dcmresponse is $TelemetryEndpointURL" >> $RTL_LOG_FILE
            fi
        fi
    fi

    if [ -z "$TelemetryEndpointURL" ]; then
        DCA_UPLOAD_URL="$DEFAULT_DCA_UPLOAD_URL"
    fi
}

getTelemetryEndpoint

if [ -z $DCA_UPLOAD_URL ]; then
    echo_t "dca upload url read from dcm.properties is NULL"
    exit 1
fi

pidCleanup()
{
   # PID file cleanup
   if [ -f /tmp/.dca-splunk.upload ];then
        rm -rf /tmp/.dca-splunk.upload
   fi
}

IsDirectBlocked()
{
    ret=0
    # Temporarily disabling blocking of direct connection due to increased load on Codebig servers.
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
      conn_type="Codebig"
      first_conn=useCodebigRequest
      sec_conn=useDirectRequest
   fi

   if [ "$CodebigAvailable" -eq 1 ]; then
      echo_t "dca : Using $conn_type connection as the Primary" >> $RTL_LOG_FILE
   else
      echo_t "dca : Only $conn_type connection is available" >> $RTL_LOG_FILE
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
       echo_t "dca$2: Using Direct commnication"
       proUpdel=`cat /tmp/DCMSettings.conf | grep -i uploadRepository:uploadProtocol | tr -dc '"' |wc -c`
       echo "number of proUPdel1:"$proUpdel
       #proUpdel=$((proUpdel - 1))
       uploadProtocoltel=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d '"' -f$proUpdel`
       echo "Upload protocol telemetry is:"$uploadProtocoltel
       if [ "$uploadProtocoltel" != "TFTP" ]; then
           echo "before HTTP upload"
           delimhttp=`cat /tmp/DCMSettings.conf | grep -i uploadRepository:uploadProtocol | tr -dc '"' |wc -c`
           echo "number of httpdeli:"$delimhttp
           delimhttp=$((delimhttp - 4))
           HTTPURL=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d '"' -f$delimhttp`
           if [ "$HTTPURL" == "" ]; then
              echo "No HTTP URL configured in xconf,going with internal one !!"
              HTTPURL=$DCM_HTTP_SERVER_URL
           fi
           echo "HTTPTELEMETRYURL:"$HTTPURL
           CURL_CMD="curl --tlsv1.2 -w '%{http_code}\n' -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d @/nvram/rtl_json.txt '$HTTPURL' --connect-timeout 30 -m 30"
           echo "------CURL_CMD:"$CURL_CMD
           HTTP_CODE=`result= eval $CURL_CMD`
           http_code=$(echo "$HTTP_CODE" | awk -F\" '{print $1}' )
           echo "http code in telemetry is :"$http_code
            #curl --tlsv1.2 -w '%{http_code}\n' -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @/nvram/hell.txt '$HTTPURL' -o "/nvram/dca_httpresult.txt" --connect-timeout 30 -m 30
           if [ $http_code -eq 200 ]; then
                 echo "HTTP telemetry curl upload succeded!!!!!!!!!!!!!!!!!"
                 ret=0
           else
                 uploadRetryCount=0
                 while [ $uploadRetryCount -lt 2 ]
                 do
                       echo "Trying to upload telemetry file..."
                       CURL_CMD="curl --tlsv1.2 -w '%{http_code}\n' -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d @/nvram/rtl_json.txt '$HTTPURL' --connect-timeout 30 -m 30"
                       HTTP_CODE=`result= eval $CURL_CMD`
                       http_code_retry=$(echo "$HTTP_CODE" | awk -F\" '{print $1}' )
                       echo "http code in telemetry is :"$http_code_retry
                       if [ "$http_code_retry" != "200" ]; then
                           echo "Error in uploading telemetry file"
                       else
                           echo "telemetry json upload succeded in retry"
                           ret=0
                           break
                       fi
                       uploadRetryCount=`expr $uploadRetryCount + 1`
                 done
                 if [ $uploadRetryCount -eq 2]; then
                      ret=1
                      echo "HTTP telemetry curl upload failed!!!!!!!!!!!!!!!!!"
                 fi
           fi
	   if [ $ret -eq 0 ]; then
              echo_t "dca$2: Direct connection success - ret:$ret " >> $RTL_LOG_FILE
              # Use direct connection for rest of the connections
              conn_type_used="Direct"
              cd ..
              return 0
           else
              echo_t "dca$2: Direct Connection Failure - ret:$ret " >> $RTL_LOG_FILE
              direct_retry=$(( direct_retry += 1 ))
              if [ "$direct_retry" -ge "$DIRECT_RETRY_COUNT" ]; then
              # .lastdirectfail will not be created for only direct connection
              [ "$CodebigAvailable" -ne "1" ] || [ -f $DIRECT_BLOCK_FILENAME ] || touch $DIRECT_BLOCK_FILENAME
             fi
             sleep 10
             cd ..
             return 1
           fi
      else
           echo "before TFTP load-----------"
           delimnr=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | tr -dc ':' |wc -c`
           echo "number of delim:"$delimnr
           delimnr=$((delimnr - 1))
           IP=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d ":" -f$delimnr | cut -d '"' -f 2`
           echo "tftp ip is :"$IP
           cd /nvram/
           if [ -f "rtl_json.txt" ]; then
              echo "rtl_json.txt available,going for tftp upload"
              iptables -t raw -I OUTPUT -j CT -p udp -m udp --dport 69 --helper tftp
              TurrisMacAddress=`ifconfig erouter0 | grep HWaddr | cut -c39-55`
              extractVal=`echo $TurrisMacAddress | sed -e 's/://g'`
              dt=`date "+%m-%d-%y-%I-%M%p"`
              cp /nvram/rtl_json.txt /nvram/$extractVal-TELE-$dt.json
              tftp -p -r $extractVal-TELE-$dt.json $IP
           else
              echo "No rtl_json.txt available,returning 1"
              return 1
           fi
           ret=$?
           echo $ret
           if [ "$ret" -eq 1 ]; then
               tftpuploadRetryCount=0
               while [ $tftpuploadRetryCount -lt 2 ]
               do
                   echo "Trying to upload telemetry file using tftp again..."
                   tftp -p -r $extractVal-TELE-$dt.json $IP
                   ret=$?
                   if [ "$ret" -eq 1 ]; then
                     echo "error in uploading using tftp"
                   else
                     echo "tftp upload in retry succeded"
                     ret=0
                     break
                   fi
                   tftpuploadRetryCount=`expr $tftpuploadRetryCount + 1`
               done
               if [ "$tftpuploadRetryCount" -eq 2]; then
                      ret=1
                      echo "TFTP telemetry  upload failed!!!!!!!!!!!!!!!!!"
               fi
           else
                echo "TFTP Telemetry succeded !!!"
                ret=0
           fi
           sleep 10

           echo_t "dca $2 : Direct Connection HTTP RESPONSE CODE : $http_code" >> $RTL_LOG_FILE
           if [ $ret -eq 0 ]; then
              echo_t "dca$2: Direct connection success - ret:$ret " >> $RTL_LOG_FILE
              # Use direct connection for rest of the connections
              conn_type_used="Direct"
              cd ..
              return 0
           else
              echo_t "dca$2: Direct Connection Failure - ret:$ret " >> $RTL_LOG_FILE
              direct_retry=$(( direct_retry += 1 ))
              if [ "$direct_retry" -ge "$DIRECT_RETRY_COUNT" ]; then
              # .lastdirectfail will not be created for only direct connection 
              [ "$CodebigAvailable" -ne "1" ] || [ -f $DIRECT_BLOCK_FILENAME ] || touch $DIRECT_BLOCK_FILENAME
             fi
             sleep 10
             cd ..
             return 1
           fi
      fi
}

# Codebig connection Download function
useCodebigRequest()
{
      # Do not try Codebig if CodebigAvailable != 1 (GetServiceUrl not there)
      if [ "$CodebigAvailable" -eq "0" ] ; then
         echo "dca$2 : Only direct connection Available"
         return 1
      fi

      if [ "x$CodeBigEnable" = "x" ] ; then
          echo_t "dca$2 : Codebig connection attempts are disabled through RFC. Exiting !!!" >> $RTL_LOG_FILE
          return 1
      fi

      if [ "$TelemetryNewEndpointAvailable" -eq "1" ]; then
          SIGN_CMD="GetServiceUrl 10 "
      else
          SIGN_CMD="GetServiceUrl 9 "
      fi
      eval $SIGN_CMD > $SIGN_FILE
      CB_SIGNED_REQUEST=`cat $SIGN_FILE`
      rm -f $SIGN_FILE
      CURL_CMD="curl $TLS -w '%{http_code}\n' --interface $EROUTER_INTERFACE $addr_type -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '$1' -o \"$HTTP_FILENAME\" \"$CB_SIGNED_REQUEST\" --connect-timeout $CURL_TIMEOUT -m $CURL_TIMEOUT"
      echo_t "dca$2: Using Codebig connection at `echo "$CURL_CMD" | sed -ne 's#.*\(https:.*\)?.*#\1#p'`" >> $RTL_LOG_FILE
      echo_t "CURL_CMD: `echo "$CURL_CMD" | sed -ne 's#oauth_consumer_key=.*oauth_signature=.* --#<hidden> --#p'`" >> $RTL_LOG_FILE
      HTTP_CODE=`curl $TLS -w '%{http_code}\n' --interface $EROUTER_INTERFACE $addr_type -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "$1" -o "$HTTP_FILENAME" "$CB_SIGNED_REQUEST" --connect-timeout $CURL_TIMEOUT -m $CURL_TIMEOUT`
      curlret=$?
      http_code=$(echo "$HTTP_CODE" | awk -F\" '{print $1}' )
      [ "x$http_code" != "x" ] || http_code=0
      # log security failure
      echo_t "dca $2 : Codebig Connection HTTP RESPONSE CODE : $http_code" >> $RTL_LOG_FILE
      case $curlret in
          35|51|53|54|58|59|60|64|66|77|80|82|83|90|91)
             echo_t "dca$2: Codebig Connection Failure - ret:$curlret http_code:$http_code" >> $RTL_LOG_FILE
             ;;
      esac
      if [ "$http_code" -eq 200 ]; then
           echo_t "dca$2: Codebig connection success - ret:$curlret http_code:$http_code" >> $RTL_LOG_FILE
           conn_type_used="Codebig"
           return 0
      fi
      if [ "$curlret" -eq 0 ]; then
          echo_t "dca$2: Codebig Connection Failure - ret:$curlret http_code:$http_code" >> $RTL_LOG_FILE
      fi
      sleep 10
    return 1
}

# Function to get erouter0 ipv4 address
getErouterIpv4()
{
    erouter_ipv4=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_IP | grep value | awk '{print $5}'`
    if [ "$erouter_ipv4" != "" ];then
        echo $erouter_ipv4
    else
        echo "null"
    fi
}

# Function to get erouter0 ipv6 address
getErouterIpv6()
{
    erouter_ipv6=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_IPv6 | grep value | awk '{print $5}'`
    if [ "$erouter_ipv6" != "" ];then
        echo $erouter_ipv6
    else
        echo "null"
    fi
}

timestamp=`date +%Y-%b-%d_%H-%M-%S`
#main app
estbMac=`getErouterMacAddress`
cur_time=`date "+%Y-%m-%d %H:%M:%S"`
erouteripv4=`getErouterIpv4`
erouteripv6=`getErouterIpv6`
DEFAULT_IPV4="<#=#>EROUTER_IPV4<#=#>"
DEFAULT_IPV6="<#=#>EROUTER_IPV6<#=#>"

# If interface doesnt have ipv6 address then we will force the curl to go with ipv4.
# Otherwise we will not specify the ip address family in curl options
addr_type=""
[ "x`ifconfig $EROUTER_INTERFACE | grep inet6 | grep -i 'Global'`" != "x" ] || addr_type="-4"

if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
   ##  1]  Pull processed data from ATOM 
   rm -f $TELEMETRY_JSON_RESPONSE

   
   GetConfigFile $PEER_COMM_ID
   scp -i $PEER_COMM_ID root@$ATOM_INTERFACE_IP:$TELEMETRY_JSON_RESPONSE $TELEMETRY_JSON_RESPONSE > /dev/null 2>&1
   if [ $? -ne 0 ]; then
       scp -i $PEER_COMM_ID root@$ATOM_INTERFACE_IP:$TELEMETRY_JSON_RESPONSE $TELEMETRY_JSON_RESPONSE > /dev/null 2>&1
   fi
   echo_t "Copied $TELEMETRY_JSON_RESPONSE " >> $RTL_LOG_FILE 
   rm -f $PEER_COMM_ID
   sleep 2
fi

# Add the erouter MAC address from ARM as this is not available in ATOM
sed -i -e "s/ErouterMacAddress/$estbMac/g" $TELEMETRY_JSON_RESPONSE


if [ ! -f $SLEEP_TIME_FILE ]; then
    if [ -f $DCMRESPONSE ]; then
        cron=`grep -i TelemetryProfile $DCMRESPONSE | awk -F '"schedule":' '{print $NF}' | awk -F "," '{print $1}' | sed 's/://g' | sed 's/"//g' | sed -e 's/^[ ]//' | sed -e 's/^[ ]//'`
    fi

    if [ -n "$cron" ]; then
        sleep_time=`echo "$cron" | awk -F '/' '{print $2}' | cut -d ' ' -f1`
    fi 

    if [ -n "$sleep_time" ];then
        sleep_time=`expr $sleep_time - 1` #Subtract 1 miute from it
        sleep_time=`expr $sleep_time \* 60` #Make it to seconds
        # Adding generic RANDOM number implementation as sh in RDK_B doesn't support RANDOM
        RANDOM=`awk -v min=5 -v max=10 'BEGIN{srand(); print int(min+rand()*(max-min+1)*(max-min+1)*1000)}'`
        sleep_time=$(($RANDOM%$sleep_time)) #Generate a random value out of it
        echo "$sleep_time" > $SLEEP_TIME_FILE
    else
        sleep_time=10
    fi
else 
    sleep_time=`cat $SLEEP_TIME_FILE`
fi

if [ -z "$sleep_time" ];then
    sleep_time=10
fi

if [ "$inputArgs" = "logbackup_without_upload" ];then
      echo_t "log backup during bootup, Will upload on later call..!"
      if [ -f $TELEMETRY_JSON_RESPONSE ]; then
           outputJson=`cat $TELEMETRY_JSON_RESPONSE`
      fi
      if [ ! -f $TELEMETRY_JSON_RESPONSE ] || [ "x$outputJson" = "x" ] ; then
               echo_t "dca: Unable to find Json message or Json is empty." >> $RTL_LOG_FILE
         if [ ! -f /etc/os-release ];then pidCleanup; fi
         exit 0
      fi
      if [ -f $TELEMETRY_RESEND_FILE ]; then
            #If resend queue has already reached MAX_CONN_QUEUE entries then remove recent two
            if [ "`cat $TELEMETRY_RESEND_FILE | wc -l`" -ge "$MAX_CONN_QUEUE" ]; then
                echo_t "resend queue size at its max. removing recent two entries" >> $RTL_LOG_FILE
                sed -i '1,2d' $TELEMETRY_RESEND_FILE
            fi
            mv $TELEMETRY_RESEND_FILE $TELEMETRY_TEMP_RESEND_FILE
      fi
      # ensure that Json is put at the top of the queue
      echo "$outputJson" > $TELEMETRY_RESEND_FILE
      if [ -f $TELEMETRY_TEMP_RESEND_FILE ] ; then
         cat $TELEMETRY_TEMP_RESEND_FILE >> $TELEMETRY_RESEND_FILE
         rm -f $TELEMETRY_TEMP_RESEND_FILE
      fi
      if [ ! -f /etc/os-release ];then pidCleanup; fi
      exit 0
fi
get_Codebigconfig
direct_retry=0
##  2] Check for unsuccessful posts from previous execution in resend que.
##  If present repost either with appending to existing or as independent post
echo "=============Telemetry has file only one upload======================="
if [ -f $TELEMETRY_RESEND_FILE ] && [ "x$ignoreResendList" != "xtrue" ]; then
    echo "=============Loop1======================="
    rm -f $TELEMETRY_TEMP_RESEND_FILE
    while read resend
    do
        resend=`echo $resend | sed "s/$DEFAULT_IPV4/$erouteripv4/" | sed "s/$DEFAULT_IPV6/$erouteripv6/"`
        echo_t "dca resend : $resend" >> $RTL_LOG_FILE 
        $first_conn "$resend" "resend" || $sec_conn "$resend" "resend" ||  conn_type_used="Fail" 

        if [ "x$conn_type_used" = "xFail" ] ; then 
           echo "$resend" >> $TELEMETRY_TEMP_RESEND_FILE
           echo_t "dca Connecion failed for this Json : requeuing back"  >> $RTL_LOG_FILE 
        fi 
        echo_t "dca Attempting next Json in the queue "  >> $RTL_LOG_FILE 
        sleep 10 
   done < $TELEMETRY_RESEND_FILE
   sleep 2
   rm -f $TELEMETRY_RESEND_FILE
fi

##  3] Attempt to post current message. Check for status if failed add it to resend queue
if [ -f $TELEMETRY_JSON_RESPONSE ]; then
   outputJson=`cat $TELEMETRY_JSON_RESPONSE`
fi
if [ ! -f $TELEMETRY_JSON_RESPONSE ] || [ "x$outputJson" = "x" ] ; then
    echo_t "dca: Unable to find Json message or Json is empty." >> $RTL_LOG_FILE
    [ ! -f $TELEMETRY_TEMP_RESEND_FILE ] ||  mv $TELEMETRY_TEMP_RESEND_FILE $TELEMETRY_RESEND_FILE
    if [ ! -f /etc/os-release ];then pidCleanup; fi
    exit 0
fi

echo "$outputJson" > $TELEMETRY_RESEND_FILE
# sleep for random time before upload to avoid bulk requests on splunk server
echo_t "dca: Sleeping for $sleep_time before upload." >> $RTL_LOG_FILE
sleep $sleep_time
timestamp=`date +%Y-%b-%d_%H-%M-%S`
$first_conn "$outputJson"  || $sec_conn "$outputJson"  ||  conn_type_used="Fail" 
if [ "x$conn_type_used" != "xFail" ]; then
    echo_t "dca: Json message successfully submitted." >> $RTL_LOG_FILE
    rm -f $TELEMETRY_RESEND_FILE
    [ ! -f $TELEMETRY_TEMP_RESEND_FILE ] ||  mv $TELEMETRY_TEMP_RESEND_FILE $TELEMETRY_RESEND_FILE
else
   if [ -f $TELEMETRY_TEMP_RESEND_FILE ] ; then
       if [ "`cat $TELEMETRY_TEMP_RESEND_FILE | wc -l `" -ge "$MAX_CONN_QUEUE" ]; then
            echo_t "dca: resend queue size has already reached MAX_CONN_QUEUE. Not adding anymore entries" >> $RTL_LOG_FILE
            mv $TELEMETRY_TEMP_RESEND_FILE $TELEMETRY_RESEND_FILE
       else
            cat $TELEMETRY_TEMP_RESEND_FILE >> $TELEMETRY_RESEND_FILE
            echo_t "dca: Json message submit failed. Adding message to resend queue" >> $RTL_LOG_FILE
       fi
       rm -f $TELEMETRY_TEMP_RESEND_FILE
    fi
fi
#rm -f $TELEMETRY_JSON_RESPONSE
# PID file cleanup
if [ ! -f /etc/os-release ];then pidCleanup; fi
