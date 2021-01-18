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

. /etc/include.properties
. /etc/device.properties

echo "inside dca_utility script with 1 as value for arguments"

if [ -f /lib/rdk/utils.sh  ]; then
   . /lib/rdk/utils.sh
fi
if [ -f /etc/mount-utils/getConfigFile.sh ];then
     . /etc/mount-utils/getConfigFile.sh
fi
source /etc/log_timestamp.sh
source /lib/rdk/getpartnerid.sh
source /lib/rdk/getaccountid.sh
EROUTER_IF=erouter0
DCMRESPONSE="$PERSISTENT_PATH/DCMresponse.txt"
DCM_SETTINGS_CONF="/tmp/DCMSettings.conf"

TELEMETRY_PATH="$PERSISTENT_PATH/.telemetry"
TELEMETRY_PATH_TEMP="$TELEMETRY_PATH/tmp"
TELEMETRY_PROFILE_PATH="$PERSISTENT_PATH/.DCMSettings.conf"
LOG_SYNC_PATH="/rdklogs/logs/"

RTL_LOG_FILE="$LOG_PATH/dcmProcessing.log"
RTL_DELTA_LOG_FILE="$RAMDISK_PATH/.rtl_temp.log"
MAP_PATTERN_CONF_FILE="$TELEMETRY_PATH/dcafile.conf"
TEMP_PATTERN_CONF_FILE="$TELEMETRY_PATH/temp_dcafile.conf"
EXEC_COUNTER_FILE="/tmp/.dcaCounter.txt"

# Persist this files for telemetry operation
# Regenerate this only when there is a change identified from XCONF update
SORTED_PATTERN_CONF_FILE="$TELEMETRY_PATH/dca_sorted_file.conf"

current_cron_file="$PERSISTENT_PATH/cron_file.txt"

#Performance oriented binaries
DCA_BINARY="/usr/bin/dca"

TELEMETRY_INOTIFY_FOLDER=/rdklogs/logs/
TELEMETRY_INOTIFY_EVENT="$TELEMETRY_INOTIFY_FOLDER/eventType.cmd"
TELEMETRY_EXEC_COMPLETE="/tmp/.dca_done"
SCP_COMPLETE="/tmp/.scp_done"

PEER_COMM_ID="/tmp/elxrretyt.swr"
IDLE_TIMEOUT=30

DEFAULT_IPV4="<#=#>EROUTER_IPV4<#=#>"
DEFAULT_IPV6="<#=#>EROUTER_IPV6<#=#>"
TELEMETRY_PREVIOUS_LOG="/tmp/.telemetry_previous_log"
TELEMETRY_PREVIOUS_LOG_COMPLETE="/tmp/.telemetry_previous_log_done"
TEMP_NVRAM_LOG_PATH="/tmp/nvram2_logs/"
NVRAM_LOG_PATH="/nvram/logs/"


# Retain source for future enabling. Defaulting to disable for now
snmpCheck=false

dcaCleanup()
{
    if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
        $CONFIGPARAMGEN jx $PEER_COMM_DAT $PEER_COMM_ID
        ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ARM_INTERFACE_IP "/bin/echo 'notifyTelemetryCleanup' > $TELEMETRY_INOTIFY_EVENT"  > /dev/null 2>&1
        echo_t "notify ARM for dca execution completion" >> $RTL_LOG_FILE
        rm -f $PEER_COMM_ID
    else
        touch $TELEMETRY_EXEC_COMPLETE
    fi

    echo_t "forced DCA execution before log upload/reboot. Clearing all markers !!!" >> $RTL_LOG_FILE
    # Forced execution before flusing of logs, so clear the markers
    if [ -d $TELEMETRY_PATH_TEMP ]; then
       rm -rf $TELEMETRY_PATH_TEMP
    fi
    rm -rf $TELEMETRY_PATH

}

# exit if an instance is already running
if [ ! -f /tmp/.dca-utility.pid ];then
    # store the PID
    echo $$ > /tmp/.dca-utility.pid
     echo "No dca-utility pid -------"
else
    echo "dca-utility pis existing----------"
    pid=`cat /tmp/.dca-utility.pid`
    if [ -d /proc/$pid ];then
        if [ "$1" == "2" ]; then
           loop=0
           while [ $loop -le 6 ]
           do
               sleep 10
               loop=$((loop+1))
               if [ ! -f /tmp/.dca-utility.pid ] || [ ! -d /proc/`cat /tmp/.dca-utility.pid` ]; then
                   dcaCleanup
                   break
               fi
           done
        fi
    	exit 0
    else
        echo $$ > /tmp/.dca-utility.pid
    fi
fi

mkdir -p $LOG_PATH
touch $RTL_LOG_FILE

previousLogPath=""
if [ -f $TELEMETRY_PREVIOUS_LOG ]; then

   isAxb6Device="no"
   if [ "$MODEL_NUM" == "TG3482G" ];then
      isNvram2Mounted=`grep nvram2 /proc/mounts`
      if [ "$isNvram2Mounted" == "" -a -d "/nvram/logs" ];then
         isAxb6Device="yes"
      fi
   fi

   if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" -a "x$isAxb6Device" == "xno" ]; then
      previousLogPath="$TEMP_NVRAM_LOG_PATH"
   elif [ "x$isAxb6Device" = "xyes" ]; then
      previousLogPath="$NVRAM_LOG_PATH"
   else
      previousLogPath="$LOG_SYNC_PATH"
   fi

   echo_t "Telemetry run for previous log path : "$previousLogPath
fi

if [ ! -f /tmp/.dca_bootup -a ! -f $TELEMETRY_PREVIOUS_LOG ]; then
   echo_t "First dca execution after bootup. Clearing all markers."
   touch /tmp/.dca_bootup
   rm -rf $TELEMETRY_PATH
   rm -f $RTL_LOG_FILE
fi


PrevFileName=''

#Adding support for opt override for dcm.properties file
if [ "$BUILD_TYPE" != "prod" ] && [ -f $PERSISTENT_PATH/dcm.properties ]; then
      . $PERSISTENT_PATH/dcm.properties
else
      . /etc/dcm.properties
fi


if [ ! -d "$TELEMETRY_PATH_TEMP" ]
then
    echo_t "Telemetry Folder does not exist . Creating now"
    mkdir -p "$TELEMETRY_PATH_TEMP"
else
    cp $TELEMETRY_PATH/rtl_* $TELEMETRY_PATH_TEMP/
fi

mkdir -p $TELEMETRY_PATH

pidCleanup()
{
   # PID file cleanup
   if [ -f /tmp/.dca-utility.pid ];then
        rm -rf /tmp/.dca-utility.pid
   fi
}

if [ $# -ne 1 ]; then
   echo "Usage : `basename $0` <0/1/2> 0 - Telemtry From Cron 1 - Reinitialize Map 2 - Forced Telemetry search " >> $RTL_LOG_FILE
   pidCleanup
   exit 0
fi

# 0 if as part of normal execution
# 1 if initiated due to an XCONF update
# 2 if forced execution before log upload
# 3 if modify the cron schedule 

triggerType=$1
echo_t "dca: Trigger type is :"$triggerType

cd $LOG_PATH


isNum()
{
    Number=$1
    if [ $Number -ne 0 -o $Number -eq 0 2>/dev/null ];then
        echo 0
    else
        echo 1
    fi
}

# Function to get erouerMAC
getEstbMac()
{

    estbMac=`dmcli eRT getv Device.DeviceInfo.X_COMCAST-COM_WAN_MAC  | grep type: | awk '{print $5}'|tr '[:lower:]' '[:upper:]'`
    
    if [ "$estbMac" ]; then
       echo "$estbMac"
    else
       if [ "$BOX_TYPE" == "XB3" ]; then
          estbMac=`/usr/bin/rpcclient $ARM_ARPING_IP "ifconfig erouter0" | grep 'Link encap:' | cut -d ' ' -f7`
          echo "$estbMac"
       else
          estbMac=`ifconfig erouter0 | grep 'Link encap:' | cut -d ' ' -f7`
          echo "$estbMac"
       fi
    fi

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

getSNMPUpdates() {
     snmpMIB=$1
     TotalCount=0
     export MIBS=ALL
     export MIBDIRS=/mnt/nfs/bin/target-snmp/share/snmp/mibs:/usr/share/snmp/mibs
     export PATH=$PATH:/mnt/nfs/bin/target-snmp/bin
     export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/nfs/bin/target-snmp/lib:/mnt/nfs/usr/lib
     snmpCommunityVal=`head -n 1 /tmp/snmpd.conf | awk '{print $4}'`
     tuneString=`snmpwalk  -OQv -v 2c -c $snmpCommunityVal 127.0.0.1 $snmpMIB`
     for count in $tuneString
     do
         count=`echo $count | tr -d ' '`
         if [ $(isNum $count) -eq 0 ]; then
            TotalCount=`expr $TotalCount + $count`
         else
            TotalCount=$count
         fi
     done
     
     echo $TotalCount
}

## Reatining for future support when net-snmp tools will be enabled in XB3s
getControllerId(){    
    ChannelMapId=''
    ControllerId=''
    VctId=''
    vodServerId=''
    export MIBS=ALL
    export MIBDIRS=/mnt/nfs/bin/target-snmp/share/snmp/mibs:/usr/share/snmp/mibs
    export PATH=$PATH:/mnt/nfs/bin/target-snmp/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/nfs/bin/target-snmp/lib:/mnt/nfs/usr/lib
    
    snmpCommunityVal=`head -n 1 /tmp/snmpd.conf | awk '{print $4}'`
    ChannelMapId=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 127.0.0.1 1.3.6.1.4.1.17270.9225.1.1.40 | awk -F '= ' '{print $2}'`
    ControllerId=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 127.0.0.1 1.3.6.1.4.1.17270.9225.1.1.41 | awk -F '= ' '{print $2}'`  
    VctId=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 127.0.0.1 OC-STB-HOST-MIB::ocStbHostCardVctId.0 | awk -F '= ' '{print $2}'`
    vodServerId=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 127.0.0.1 1.3.6.1.4.1.17270.9225.1.1.43 | awk -F '= ' '{print $2}'`
    
    echo "{\"ChannelMapId\":\"$ChannelMapId\"},{\"ControllerId\":\"$ControllerId\"},{\"VctId\":$VctId},{\"vodServerId\":\"$vodServerId\"}"    
}

# Function to get RF status
## Reatining for future support when net-snmp tools will be enabled in XB3s
getRFStatus(){
    Dwn_RX_pwr=''
    Ux_TX_pwr=''
    Dx_SNR=''
    export MIBS=ALL
    export MIBDIRS=/mnt/nfs/bin/target-snmp/share/snmp/mibs
    export PATH=$PATH:/mnt/nfs/bin/target-snmp/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/nfs/bin/target-snmp/lib:/mnt/nfs/usr/lib
    
    snmpCommunityVal=`head -n 1 /tmp/snmpd.conf | awk '{print $4}'`
    Dwn_RX_pwr=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 192.168.100.1 DOCS-IF-MIB::docsIfDownChannelPower.3 | awk -F '= ' '{print $2}'`
    Ux_TX_pwr=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 192.168.100.1 DOCS-IF-MIB::docsIfCmStatusTxPower.2 | awk -F '= ' '{print $2}'`  
    Dx_SNR=`snmpwalk -OQ -v 2c -c $snmpCommunityVal 192.168.100.1 DOCS-IF-MIB::docsIfSigQSignalNoise.3 | awk -F '= ' '{print $2}'`
    
    echo "{\"Dwn_RX_pwr\":\"$Dwn_RX_pwr\"},{\"Ux_TX_pwr\":\"$Ux_TX_pwr\"},{\"Dx_SNR\":\"$Dx_SNR\"}"
}

processJsonResponse()
{
    FILENAME=$1
    #Condider getting the filename as an argument instead of using global file name
    if [ -f "$FILENAME" ]; then
        # Start pre-processing the original file
        sed -i 's/,"urn:/\n"urn:/g' $FILENAME # Updating the file by replacing all ',"urn:' with '\n"urn:'
        sed -i 's/^{//g' $FILENAME # Delete first character from file '{'
        sed -i 's/}$//g' $FILENAME # Delete first character from file '}'
        echo "" >> $FILENAME         # Adding a new line to the file
        # Start pre-processing the original file

        OUTFILE=$DCM_SETTINGS_CONF
        OUTFILEOPT="$PERSISTENT_PATH/.DCMSettings.conf"
        #rm -f $OUTFILE #delete old file
        cat /dev/null > $OUTFILE #empty old file
        cat /dev/null > $OUTFILEOPT
        while read line
        do
            # Special processing for telemetry
            profile_Check=`echo "$line" | grep -ci 'TelemetryProfile'`
            if [ $profile_Check -ne 0 ];then
                #echo "$line"
                echo "$line" | sed 's/"header":"/"header" : "/g' | sed 's/"content":"/"content" : "/g' | sed 's/"type":"/"type" : "/g' >> $OUTFILE

                echo "$line" | sed 's/"header":"/"header" : "/g' | sed 's/"content":"/"content" : "/g' | sed 's/"type":"/"type" : "/g' | sed -e 's/uploadRepository:URL.*","//g'  >> $OUTFILEOPT
            else
                echo "$line" | sed 's/":/=/g' | sed 's/"//g' >> $OUTFILE
            fi
        done < $FILENAME
    else
        echo "$FILENAME not found." >> $RTL_LOG_FILE
        return 1
    fi
}

scheduleCron()
{
    echo "schedulecronjob!!"
    cron=''
    scheduler_Check=`grep '"schedule":' $DCM_SETTINGS_CONF`
    if [ -n "$scheduler_Check" ]; then
        cron=`grep -i TelemetryProfile $DCM_SETTINGS_CONF | awk -F '"schedule":' '{print $NF}' | awk -F "," '{print $1}' | sed 's/://g' | sed 's/"//g' | sed -e 's/^[ ]//' | sed -e 's/^[ ]//'`
    fi

	#During diagnostic mode need to apply the cron schedule value through this custom configuration
	DiagnosticMode=`dmcli eRT getv Device.SelfHeal.X_RDKCENTRAL-COM_DiagnosticMode | grep value | cut -f3 -d : | cut -f2 -d" "`
	if [ "$DiagnosticMode" == "true" ];then
	LogUploadFrequency=`dmcli eRT getv Device.SelfHeal.X_RDKCENTRAL-COM_DiagMode_LogUploadFrequency | grep value | cut -f3 -d : | cut -f2 -d" "`
		if [ "$LogUploadFrequency" != "" ]; then
			cron=''
			cron="*/$LogUploadFrequency * * * *"
			echo "$timestamp dca: the default Cron schedule from XCONF is ignored and instead SNMP overriden value is used" >> $RTL_LOG_FILE
		fi
	fi	

	#Check whether cron having empty value if it is empty then need to assign 
	#15mins by default
	if [ -z "$cron" ]; then
		echo "$timestamp: dca: Empty cron value so set default as 15mins"
		cron="*/15 * * * *"
	fi	

    if [ -n "$cron" ]; then
	# Dump existing cron jobs to a file
	crontab -l -c $CRON_SPOOL > $current_cron_file
	# Check whether any cron jobs are existing or not
	existing_cron_check=`cat $current_cron_file | tail -n 1`
	tempfile="$PERSISTENT_PATH/tempfile.txt"
	rm -rf $tempfile  # Delete temp file if existing
	if [ -n "$existing_cron_check" ]; then
		rtl_cron_check=`grep -c 'dca_utility.sh' $current_cron_file`
		if [ $rtl_cron_check -eq 0 ]; then
			echo "$cron nice -n 19 sh $RDK_PATH/dca_utility.sh 1" >> $tempfile
		fi
		while read line
		do
			retval=`echo "$line" | grep 'dca_utility.sh'`
			if [ -n "$retval" ]; then
				echo "$cron nice -n 19 sh $RDK_PATH/dca_utility.sh 1" >> $tempfile
			else
				echo "$line" >> $tempfile
			fi
		done < $current_cron_file
	else
		# If no cron job exists, create one, with the value from DCMSettings.conf file
		echo "$cron nice -n 19 sh $RDK_PATH/dca_utility.sh 1" >> $tempfile
	fi
	# Set new cron job from the file
	crontab $tempfile -c $CRON_SPOOL
	rm -rf $current_cron_file # Delete temp file
	rm -rf $tempfile          # Delete temp file
    else
	echo " `date` Failed to read \"schedule\" cronjob value from DCMSettings.conf." >> $RTL_LOG_FILE
    fi
}

dropbearRecovery()
{
   dropbearPid=`ps | grep -i dropbear | grep "$ATOM_INTERFACE_IP" | grep -v grep`
   if [ -z "$dropbearPid" ]; then
       DROPBEAR_PARAMS_1="/tmp/.dropbear/dropcfg1$$"
       DROPBEAR_PARAMS_2="/tmp/.dropbear/dropcfg2$$"
       if [ ! -d '/tmp/.dropbear' ]; then
          echo "wan_ssh.sh: need to create dropbear dir !!! " >> $RTL_LOG_FILE
          mkdir -p /tmp/.dropbear
       fi
       echo "wan_ssh.sh: need to create dropbear files !!! " >> $RTL_LOG_FILE
       getConfigFile $DROPBEAR_PARAMS_1
       getConfigFile $DROPBEAR_PARAMS_2
       dropbear -r $DROPBEAR_PARAMS_1 -r $DROPBEAR_PARAMS_2 -E -s -p $ATOM_INTERFACE_IP:22 &
       sleep 2
   fi
   rm -rf /tmp/.dropbear/*
}
   
clearTelemetryConfig()
{
    echo_t "dca: Clearing telemetry config and markers" >> $RTL_LOG_FILE
    if [ -f $RTL_DELTA_LOG_FILE ]; then
        echo_t "dca: Deleting : $RTL_DELTA_LOG_FILE" >> $RTL_LOG_FILE
        rm -f $RTL_DELTA_LOG_FILE
    fi

    if [ -f $MAP_PATTERN_CONF_FILE ]; then
        echo_t "dca: MAP_PATTERN_CONF_FILE : $MAP_PATTERN_CONF_FILE" >> $RTL_LOG_FILE
        rm -f $MAP_PATTERN_CONF_FILE
    fi

    if [ -f $TEMP_PATTERN_CONF_FILE ]; then
        echo_t "dca: TEMP_PATTERN_CONF_FILE : $TEMP_PATTERN_CONF_FILE" >> $RTL_LOG_FILE
        rm -f $TEMP_PATTERN_CONF_FILE
    fi

    if [ -f $SORTED_PATTERN_CONF_FILE ]; then
        echo_t "dca: SORTED_PATTERN_CONF_FILE : $SORTED_PATTERN_CONF_FILE" >> $RTL_LOG_FILE
        rm -f $SORTED_PATTERN_CONF_FILE
    fi

    # Clear markers with XCONF update as logs will be flushed in case of maintenance window case as well. 
    # During boot-up no need of maintaining old markers.
    if [ -d $TELEMETRY_PATH ]; then
        rm -rf $TELEMETRY_PATH
        mkdir -p $TELEMETRY_PATH
    fi

    if [ -d $TELEMETRY_PATH_TEMP ]; then
        rm -rf $TELEMETRY_PATH_TEMP
        mkdir -p $TELEMETRY_PATH_TEMP
    fi

}

## Pass The I/P O/P Files As Arguments
generateTelemetryConfig()
{
    echo_t "dca: Generating telemetry config file." >> $RTL_LOG_FILE
    input_file=$1
    output_file=$2
    touch $TEMP_PATTERN_CONF_FILE
    if [ -f $input_file ]; then
      grep -i 'TelemetryProfile' $input_file | sed 's/=\[/\n/g' | sed 's/},/}\n/g' | sed 's/],.*?/\n/g'| sed -e 's/^[ ]//' > $TEMP_PATTERN_CONF_FILE
    fi

  # Create map file from json message file
    while read line
    do         
        header_Check=`echo "$line" | grep -c '{"header"'`
        if [ $header_Check -ne 0 ];then
           polling=`echo "$line" | grep -c 'pollingFrequency'`
           if [ $polling -ne 0 ];then
              header=`echo "$line" | awk -F '"header" :' '{print $NF}' | awk -F '",' '{print $1}' | sed -e 's/^[ ]//' | sed 's/^"//'`
              content=`echo "$line" | awk -F '"content" :' '{print $NF}' | awk -F '",' '{print $1}' | sed -e 's/^[ ]//' | sed 's/^"//'`
              logFileName=`echo "$line" | awk -F '"type" :' '{print $NF}' | awk -F '",' '{print $1}' | sed -e 's/^[ ]//' | sed 's/^"//'`
              skipInterval=`echo "$line" | sed -e "s/.*pollingFrequency\":\"//g" | sed 's/"}//'`
           else
              header=`echo "$line" | awk -F '"header" :' '{print $NF}' | awk -F '",' '{print $1}' | sed -e 's/^[ ]//' | sed 's/^"//'`
              content=`echo "$line" | awk -F '"content" :' '{print $NF}' | awk -F '",' '{print $1}' | sed -e 's/^[ ]//' | sed 's/^"//'`
              logFileName=`echo "$line" | awk -F '"type" :' '{print $NF}' | sed -e 's/^[ ]//' | sed 's/^"//' | sed 's/"}//'`
              #default value to 0
              skipInterval=0
           fi 

           if [ -n "$header" ] && [ -n "$content" ] && [ -n "$logFileName" ] && [ -n "$skipInterval" ]; then
              echo "$header<#=#>$content<#=#>$logFileName<#=#>$skipInterval" >> $MAP_PATTERN_CONF_FILE
           fi
        fi
    done < $TEMP_PATTERN_CONF_FILE
    # Sort the config file based on file names to minimise the duplicate delta file generation
    if [ -f $MAP_PATTERN_CONF_FILE ]; then
        if [ -f $output_file ]; then
            rm -f $output_file
        fi
        awk -F '<#=#>' '{print $3,$0}' $MAP_PATTERN_CONF_FILE | sort -n | cut -d ' ' -f 2- > $output_file
    fi

}

      echo "triggertype------------"$triggerType
# Reschedule the cron based on diagnositic mode
if [ $triggerType -eq 3 ] ; then
	echo_t "$timestamp: dca: Processing rescheduleCron job" >> $RTL_LOG_FILE
    scheduleCron
    ## Telemetry must be invoked only for reschedule cron job
    pidCleanup
    exit 0
fi

# Pull the settings from Telemetry server periodically
estbMacAddress=`ifconfig erouter0 | grep HWaddr | cut -c39-55`
JSONSTR=$estbMacAddress
CURL_CMD="curl '$DCM_LOG_SERVER_URL?estbMacAddress=$JSONSTR&model=$MODEL_NAME' -o $DCMRESPONSE > /tmp/httpcode.txt"

# Execute curl command
result= eval $CURL_CMD
sleep 5
echo "sleep for :------------------$timeout"

# Regenerate config only during boot-up and when there is an update
if [ ! -f $SORTED_PATTERN_CONF_FILE ] || [ $triggerType -eq 1 -a ! -f $TELEMETRY_PREVIOUS_LOG ] ; then
# Start crond daemon for yocto builds
    pidof crond
    if [ $? -ne 0 ]; then
        mkdir -p $CRON_SPOOL
        touch $CRON_SPOOL/root
        crond -c $CRON_SPOOL -l 9
    fi

    if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
        while [ ! -f $DCMRESPONSE ]
        do
            echo "WARNING !!! Unable to locate $DCMRESPONSE .. Retrying " >> $RTL_LOG_FILE
            GetConfigFile $PEER_COMM_ID
            scp -i $PEER_COMM_ID -r $ARM_INTERFACE_IP:$DCMRESPONSE $DCMRESPONSE > /dev/null 2>&1
            rm -f $PEER_COMM_ID
            sleep 10
        done
    fi
      echo "calling processJsonResponse--------"
    processJsonResponse $DCMRESPONSE
      echo "after calling processJsonResponse-----------"
    clearTelemetryConfig
      echo "after calling clearTelemetryConfig-----------"
    generateTelemetryConfig $TELEMETRY_PROFILE_PATH $SORTED_PATTERN_CONF_FILE
      echo "after calling generateTelemetryConfig--------"
    scheduleCron
      echo "after calling scheduleCron-------------------"
    if [ $triggerType -eq 1 ]; then
        bootupTelemetryBackup=true
        ## Telemetry must be invoked only via cron and not during boot-up
	# pidCleanup
        #exit 0
    fi
fi

mkdir -p $TELEMETRY_PATH_TEMP

if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
    dropbearRecovery
    mkdir -p $LOG_PATH
    TMP_SCP_PATH="/tmp/scp_logs"
    mkdir -p $TMP_SCP_PATH
    GetConfigFile $PEER_COMM_ID
    scp -i $PEER_COMM_ID -r $ARM_INTERFACE_IP:$LOG_PATH/* $TMP_SCP_PATH/ > /dev/null 2>&1
    scp -i $PEER_COMM_ID -r $ARM_INTERFACE_IP:$LOG_SYNC_PATH/$SelfHealBootUpLogFile  $ARM_INTERFACE_IP:$LOG_SYNC_PATH/$PcdLogFile  $TMP_SCP_PATH/ > /dev/null 2>&1
    rm -f $PEER_COMM_ID

    RPC_RES=`rpcclient $ARM_ARPING_IP "touch $SCP_COMPLETE"`
    RPC_OK=`echo $RPC_RES | grep "RPC CONNECTED"`
    if [ "$RPC_OK" == "" ]; then
	 echo_t "RPC touch failed : attemp 1"

	 RPC_RES=`rpcclient $ARM_ARPING_IP "touch $SCP_COMPLETE"`
     RPC_OK=`echo $RPC_RES | grep "RPC CONNECTED"`
	 if [ "$RPC_OK" == "" ]; then
		echo_t "RPC touch failed : attemp 2"
	 fi
    fi

    ATOM_FILE_LIST=`echo ${ATOM_FILE_LIST} | sed -e "s/{//g" -e "s/}//g" -e "s/,/ /g"`
    for file in $ATOM_FILE_LIST
    do
        if [ -f $TMP_SCP_PATH/$file ]; then
            rm -f $TMP_SCP_PATH/$file
        fi
    done

    if [ -d $TMP_SCP_PATH ]; then
        cp -r $TMP_SCP_PATH/* $LOG_PATH/
        rm -rf $TMP_SCP_PATH
    fi

    sleep 2
fi

#Clear the final result file
rm -f $TELEMETRY_JSON_RESPONSE


## Generate output file with pattern to match count values
if [ ! -f $SORTED_PATTERN_CONF_FILE ]; then
    echo "WARNING !!! Unable to locate telemetry config file $SORTED_PATTERN_CONF_FILE. Exiting !!!" >> $RTL_LOG_FILE
else
    # echo_t "Using telemetry pattern stored in : $SORTED_PATTERN_CONF_FILE.!!!" >> $RTL_LOG_FILE
    defaultOutputJSON="{\"searchResult\":[{\"<remaining_keys>\":\"<remaining_values>\"}]}"
    echo "nice -n 19 $DCA_BINARY $SORTED_PATTERN_CONF_FILE $previousLogPath" >> $RTL_LOG_FILE
    dcaOutputJson=`nice -n 19 $DCA_BINARY $SORTED_PATTERN_CONF_FILE $previousLogPath 2>> $RTL_LOG_FILE`
    if [ -z "$dcaOutputJson" ];
    then
      dcaOutputJson=$defaultOutputJSON
    fi

    echo "dcaoutputjson----!!!!!!!!!!!!----"$dcaOutputJson
    singleEntry=true

    # Get the snmp and performance values when enabled 
    # Need to check only when SNMP is enabled in future
    if [ "$snmpCheck" == "true" ] ; then
      while read line
      do
        pattern=`echo "$line" | awk -F '<#=#>' '{print $1}'`
        filename=`echo "$line" | awk -F '<#=#>' '{print $2}'`
        if [ $filename == "snmp" ] || [ $filename == "SNMP" ]; then
            retvalue=$(getSNMPUpdates $pattern)
            header=`grep "$pattern<#=#>$filename" $MAP_PATTERN_CONF_FILE | head -n 1 | awk -F '<#=#>' '{print $1}'`
            if $singleEntry ; then
               tuneData="{\"$header\":\"$retvalue\"}"
               outputJson="$outputJson$tuneData"
               singleEntry=false
            else
               tuneData=",{\"$header\":\"$retvalue\"}"
               outputJson="$outputJson$tuneData" 
            fi                
        fi
       done < $SORTED_PATTERN_CONF_FILE
     fi
     

       ## This interface is not accessible from ATOM, replace value from ARM
       estbMac=$(getEstbMac)
       firmwareVersion=$(getFWVersion)
       firmwareVersion=$(echo $firmwareVersion | sed -e "s/imagename://g")
       partnerId=$(getPartnerId)
       accountId=$(getAccountId)
       erouterIpv4=$(getErouterIpv4)
       erouterIpv6=$(getErouterIpv6)

       
       if [ "$triggerType" = "1" ]; then
          if [ "$erouterIpv4" = "null" ]; then
              erouterIpv4="$DEFAULT_IPV4"
          fi
          if [ "$erouterIpv6" = "null" ]; then
              erouterIpv6="$DEFAULT_IPV6"
          fi
       fi

       cur_time=`date "+%Y-%m-%d %H:%M:%S"`
     
       if $singleEntry ; then
            outputJson="$outputJson{\"Profile\":\"RDKB\"},{\"mac\":\"$estbMac\"},{\"erouterIpv4\":\"$erouterIpv4\"},{\"erouterIpv6\":\"$erouterIpv6\"},{\"PartnerId\":\"$partnerId\"},{\"AccountId\":\"$accountId\"},{\"Version\":\"$firmwareVersion\"},{\"Time\":\"$cur_time\"}"
            singleEntry=false
       else
            outputJson="$outputJson,{\"Profile\":\"RDKB\"},{\"mac\":\"$estbMac\"},{\"erouterIpv4\":\"$erouterIpv4\"},{\"erouterIpv6\":\"$erouterIpv6\"},{\"PartnerId\":\"$partnerId\"},{\"AccountId\":\"$accountId\"},{\"Version\":\"$firmwareVersion\"},{\"Time\":\"$cur_time\"}"
       fi
       echo "outputjson---------------"$outputJson

       remain="{\"<remaining_keys>\":\"<remaining_values>\"}"
       outputJson=`echo "$dcaOutputJson" | sed "s/$remain/$outputJson/"`
       echo "outputjson1---------------"$outputJson
       echo "$outputJson" > $TELEMETRY_JSON_RESPONSE
       sleep 2

       echo "TELEMETRY_JSON_RESPONSE file is -----------"$TELEMETRY_JSON_RESPONSE
       if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
           echo "Notify ARM to pick the updated JSON message in $TELEMETRY_JSON_RESPONSE and upload to splunk" >> $RTL_LOG_FILE
           # Trigger inotify event on ARM to upload message to splunk
           GetConfigFile $PEER_COMM_ID
           if [ $triggerType -eq 2 ]; then
                    ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ARM_INTERFACE_IP "/bin/echo 'notifyFlushLogs' > $TELEMETRY_INOTIFY_EVENT"  > /dev/null 2>&1
                    echo_t "notify ARM for dca execution completion" >> $RTL_LOG_FILE
           else
               if [ -f $TELEMETRY_PREVIOUS_LOG -a $triggerType -eq 1 ];then
                    ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ARM_INTERFACE_IP "/bin/echo 'previousLog' > $TELEMETRY_INOTIFY_EVENT"  > /dev/null 2>&1
                    echo_t "notify ARM for dca running is for previous log" >> $RTL_LOG_FILE
	       else
               	    if [ "$bootupTelemetryBackup" = "true" -a $triggerType -eq 1 ];then
               	         ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ARM_INTERFACE_IP "/bin/echo 'bootupBackup' > $TELEMETRY_INOTIFY_EVENT" > /dev/null 2>&1
               	    else
               	         ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ARM_INTERFACE_IP "/bin/echo 'splunkUpload' > $TELEMETRY_INOTIFY_EVENT" > /dev/null 2>&1
               	    fi
               fi
           fi
           rm -f $PEER_COMM_ID
       else
           if [ $triggerType -eq 2 ]; then
               touch $TELEMETRY_EXEC_COMPLETE
           fi
           if [ $triggerType -eq 1 -a -f $TELEMETRY_PREVIOUS_LOG ];
           then
              echo "calling splunkupload----------------------------"
              sh /lib/rdk/dcaSplunkUpload.sh logbackup_without_upload &
           else
              sh /lib/rdk/dcaSplunkUpload.sh &
           fi
           proUpdel=`cat /tmp/DCMSettings.conf | grep -i uploadRepository:uploadProtocol | tr -dc '"' |wc -c`
           echo "number of proUPdel:"$proUpdel
           #proUpdel=$((proUpdel - 1))
           uploadProto=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d '"' -f$proUpdel`
           echo "Upload protocol is:"$uploadProto
           if [ "$uploadProto" != "TFTP" ]; then
             HTTPLOGUPLOADURL=`cat /tmp/DCMSettings.conf | grep -i "urn:settings:LogUploadSettings:RepositoryURL" | cut -d "=" -f2`
             if [ "$HTTPLOGUPLOADURL" == "" ]; then
                echo "No HTTP URL configured in xconf,going with internal one !!"
                HTTPLOGUPLOADURL=$DCM_LA_SERVER_URL
             fi
             echo "HTTPURL:"$HTTPLOGUPLOADURL
             sh $RDK_PATH/uploadSTBLogs.sh $HTTPLOGUPLOADURL 1 1 1 0 0 &
           else
             delimnr=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | tr -dc ':' |wc -c`
             echo "number of deli:"$delimnr
             delimnr=$((delimnr - 1))
             TFTPIP=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d ":" -f$delimnr | cut -d '"' -f 2`
             echo "TFTPIP:"$TFTPIP
             sh $RDK_PATH/uploadSTBLogs.sh $TFTPIP 1 1 1 0 0 &
           fi
       fi
fi

if [ -f $RTL_DELTA_LOG_FILE ]; then
    rm -f $RTL_DELTA_LOG_FILE
fi

if [ -f $TEMP_PATTERN_CONF_FILE ]; then
    rm -f $TEMP_PATTERN_CONF_FILE
fi

if [ $triggerType -eq 2 ]; then
   echo_t "forced DCA execution before log upload/reboot. Clearing all markers !!!" >> $RTL_LOG_FILE
   # Forced execution before flusing of logs, so clear the markers
   if [ -d $TELEMETRY_PATH_TEMP ]; then
       rm -rf $TELEMETRY_PATH_TEMP
   fi
   rm -rf $TELEMETRY_PATH

fi

if [ -f $EXEC_COUNTER_FILE ]; then
    dcaNexecCounter=`cat $EXEC_COUNTER_FILE`
    dcaNexecCounter=`expr $dcaNexecCounter + 1`
else
    dcaNexecCounter=0;
fi

if [ -f $TELEMETRY_PREVIOUS_LOG ]; then
    echo_t "dca for previous log done" >> $RTL_LOG_FILE
    rm -f $TELEMETRY_PREVIOUS_LOG $SORTED_PATTERN_CONF_FILE
    rm -rf $TEMP_NVRAM_LOG_PATH
    touch $TELEMETRY_PREVIOUS_LOG_COMPLETE
fi

echo "$dcaNexecCounter" > $EXEC_COUNTER_FILE
# PID file cleanup
pidCleanup
