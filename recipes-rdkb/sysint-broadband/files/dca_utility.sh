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
if [ -f /etc/telemetry2_0.properties ]; then
    . /etc/telemetry2_0.properties
fi

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
DCM_SETTINGS_CONF="/tmp/DcaSettings.conf"

TELEMETRY_PATH="$PERSISTENT_PATH/.telemetry"
# Path to store log file seek values
TELEMETRY_PATH_TEMP="$TELEMETRY_PATH/tmp"

TELEMETRY_PROFILE_PATH="/tmp/.DCMSettings.conf"
LOG_SYNC_PATH="/nvram2/logs/"

RTL_LOG_FILE="$LOG_PATH/dcmProcessing.log"
RTL_DELTA_LOG_FILE="$RAMDISK_PATH/.rtl_temp.log"

EXEC_COUNTER_FILE="/tmp/.dcaCounter.txt"

# Persist this files for telemetry operation
# Regenerate this only when there is a change identified from XCONF update
SORTED_PATTERN_CONF_FILE="$TELEMETRY_PATH/dca_sorted_file.conf"

current_cron_file="/tmp/cron_file$$.txt"

#Performance oriented binaries
DCA_BINARY="/usr/bin/dca"

TELEMETRY_INOTIFY_FOLDER=/telemetry
TELEMETRY_INOTIFY_EVENT="$TELEMETRY_INOTIFY_FOLDER/eventType.cmd"
TELEMETRY_T2_INOTIFY_EVENT="/tmp/t2events/eventType.cmd"
TELEMETRY_EXEC_COMPLETE="/tmp/.dca_done"


SCP_COMPLETE="/tmp/.scp_done"
PEER_COMM_ID="/tmp/elxrretyt-dca.swr"
IDLE_TIMEOUT=30

MAX_SSH_RETRY=3

## For simple T2.0 migration consider only below steps for T2 Enable mode
T2_ENABLE=`syscfg get T2Enable`
echo_t "RFC value for Telemetry 2.0 Enable is $T2_ENABLE ." >> $RTL_LOG_FILE
echo_t "RFC value for Telemetry 2.0 Enable is $T2_ENABLE ." >> $T2_0_LOGFILE

if [ ! -f $T2_0_BIN ]; then
    echo_t  "Unable to find $T2_0_BIN ... Switching T2 Enable to false !!!" >> $RTL_LOG_FILE
    T2_ENABLE="false"
fi

if [ "x$T2_ENABLE" == "xtrue" ]; then
    t2Pid=`pidof $T2_0_APP`
    triggerType=$1
    echo_t "Entering T2_0_APP mode - Trigger type is $triggerType" >> $T2_0_LOGFILE
    echo_t "Entering T2_0_APP mode - Trigger type is $triggerType" >> $RTL_LOG_FILE
    if [ ! -z "$t2Pid" ]; then
        if [ $triggerType -eq 2 ]; then
            echo_t "$0 : forced DCA execution before log upload/reboot. Signalling $T2_0_APP with level SIGUSR1 !!!" >> $T2_0_LOGFILE
            kill -10 $t2Pid
            sleep 120
            if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then 
            	echo_t "$0 : exec utils remotely for clearing markers" >> $T2_0_LOGFILE
		if [ ! -f $PEER_COMM_ID ]; then
                    GetConfigFile $PEER_COMM_ID
		fi
            	ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ATOM_INTERFACE_IP "echo 'clearSeekValues' > $TELEMETRY_T2_INOTIFY_EVENT"  > /dev/null 2>&1
		sleep 1
            else 
                echo_t "$0 : Clearing markers from $TELEMETRY_PATH" >> $T2_0_LOGFILE
            	rm -rf $TELEMETRY_PATH_TEMP
            	mkdir -p $TELEMETRY_PATH_TEMP
            fi
        fi

        if [ $triggerType -eq 1 ]; then
            echo_t "$0 : Trigger from maintenance window" >> $T2_0_LOGFILE
            echo_t "$0 : Send signal $T2_0_APP to restart for config fetch " >> $T2_0_LOGFILE
            kill -15 $t2Pid
        fi
    else
            echo_t "Pid for $T2_0_APP is $t2Pid . No active $T2_0_APP instances found " >> $T2_0_LOGFILE
    fi

    echo_t "$0 : Exiting ..." >> $T2_0_LOGFILE
    exit 0
fi

if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
    CRON_SPOOL=/tmp/cron
    if [ ! -f /usr/bin/GetConfigFile ];then
        echo "Error: GetConfigFile Not Found"
        exit 127
    fi

    if [ -f /etc/logFiles.properties ]; then
        . /etc/logFiles.properties
    fi
    
fi

sshCmdOnArm(){

    command=$1
    if [ ! -f $PEER_COMM_ID ]; then
        GetConfigFile $PEER_COMM_ID
    fi
    count=0
    isCmdExecFail="true"
    while [ $count -lt $MAX_SSH_RETRY ]
    do
        ssh -I $IDLE_TIMEOUT -i $PEER_COMM_ID root@$ARM_INTERFACE_IP "echo $command > $TELEMETRY_INOTIFY_EVENT"  > /dev/null 2>&1
        ret=$?
        if [ $ret -ne 0 ]; then
            echo_t "$count : SSH command execution failure to ARM for $command. Retrying..." >> $RTL_LOG_FILE
            sleep 10
        else
            count=$MAX_SSH_RETRY
            isCmdExecFail="false"
        fi
        count=$((count + 1))
    done

    if [ "x$isCmdExecFail" == "xtrue" ]; then
        echo_t "Failed to exec command $command on arm with $MAX_SSH_RETRY retries" >> $RTL_LOG_FILE
    fi

}

dcaCleanup()
{
    if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
        sshCmdOnArm 'notifyTelemetryCleanup'
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
else
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

if [ ! -f /tmp/.dca_bootup ]; then
   echo_t "First dca execution after bootup. Clearing all markers." >> $RTL_LOG_FILE
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
    echo_t "Telemetry Folder does not exist . Creating now" >> $RTL_LOG_FILE
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
echo_t "dca: Trigger type is $triggerType" >> $RTL_LOG_FILE

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
	# /nvram/DCMresponse.txt
    FILENAME=$1
    #Condider getting the filename as an argument instead of using global file name
    if [ -f "$FILENAME" ]; then
    	# Use tmp files for inline stream editing
        tmpConfigFile="/tmp/dcm$$.txt"
        cp $FILENAME $tmpConfigFile
        # Start pre-processing the original file
        sed -i 's/,"urn:/\n"urn:/g' $tmpConfigFile # Updating the file by replacing all ',"urn:' with '\n"urn:'
        sed -i 's/^{//g' $tmpConfigFile # Delete first character from file '{'
        sed -i 's/}$//g' $tmpConfigFile # Delete first character from file '}'
        echo "" >> $tmpConfigFile         # Adding a new line to the file
        # End pre-processing the original file
        mv $tmpConfigFile $FILENAME        
        #rm -f $OUTFILE #delete old file
        cat /dev/null > $DCM_SETTINGS_CONF #empty old file
        cat /dev/null > $TELEMETRY_PROFILE_PATH
        while read line
        do
            # Special processing for telemetry
            profile_Check=`echo "$line" | grep -ci 'TelemetryProfile'`
            if [ $profile_Check -ne 0 ];then
                #echo "$line"
                echo "$line" | sed 's/"header":"/"header" : "/g' | sed 's/"content":"/"content" : "/g' | sed 's/"type":"/"type" : "/g' >> $DCM_SETTINGS_CONF

                echo "$line" | sed 's/"header":"/"header" : "/g' | sed 's/"content":"/"content" : "/g' | sed 's/"type":"/"type" : "/g' | sed -e 's/uploadRepository:URL.*","//g'  >> $TELEMETRY_PROFILE_PATH
            else
                echo "$line" | sed 's/":/=/g' | sed 's/"//g' >> $DCM_SETTINGS_CONF
            fi
        done < $FILENAME
    else
        echo "$FILENAME not found." >> $RTL_LOG_FILE
        return 1
    fi
}

scheduleCron()
{
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
		echo "$timestamp: dca: Empty cron value so set default as 15mins" >> $RTL_LOG_FILE
		cron="*/15 * * * *"
	fi	

    if [ -n "$cron" ]; then
	# Dump existing cron jobs to a file
	crontab -l -c $CRON_SPOOL > $current_cron_file
	# Check whether any cron jobs are existing or not
	existing_cron_check=`cat $current_cron_file | tail -n 1`
	tempfile="$PERSISTENT_PATH/tempfile$$.txt"
	rm -rf $tempfile  # Delete temp file if existing
	if [ -n "$existing_cron_check" ]; then
		rtl_cron_check=`grep -c 'dca_utility.sh' $current_cron_file`
		if [ $rtl_cron_check -eq 0 ]; then
			echo "$cron nice -n 19 sh $RDK_PATH/dca_utility.sh 0" >> $tempfile
		fi
		while read line
		do
			retval=`echo "$line" | grep 'dca_utility.sh'`
			if [ -n "$retval" ]; then
				echo "$cron nice -n 19 sh $RDK_PATH/dca_utility.sh 0" >> $tempfile
			else
				echo "$line" >> $tempfile
			fi
		done < $current_cron_file
	else
		# If no cron job exists, create one, with the value from DCMSettings.conf file
		echo "$cron nice -n 19 sh $RDK_PATH/dca_utility.sh 0" >> $tempfile
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
       DROPBEAR_PARAMS_1="/tmp/.dropbear/dropcfg1_dcautil"
       DROPBEAR_PARAMS_2="/tmp/.dropbear/dropcfg2_dcautil"
       if [ ! -d '/tmp/.dropbear' ]; then
          echo_t "wan_ssh.sh: need to create dropbear dir !!! " >> $RTL_LOG_FILE
          mkdir -p /tmp/.dropbear
       fi
       echo_t "wan_ssh.sh: need to create dropbear files !!! " >> $RTL_LOG_FILE
       if [ ! -f $DROPBEAR_PARAMS_1 ]; then
           getConfigFile $DROPBEAR_PARAMS_1
       fi
       if [ ! -f $DROPBEAR_PARAMS_2 ]; then
           getConfigFile $DROPBEAR_PARAMS_2
       fi
       dropbear -r $DROPBEAR_PARAMS_1 -r $DROPBEAR_PARAMS_2 -E -s -p $ATOM_INTERFACE_IP:22 &
       sleep 2
   fi
}
   
clearTelemetryConfig()
{
    echo_t "dca: Clearing telemetry config and markers" >> $RTL_LOG_FILE
    if [ -f $RTL_DELTA_LOG_FILE ]; then
        echo_t "dca: Deleting : $RTL_DELTA_LOG_FILE" >> $RTL_LOG_FILE
        rm -f $RTL_DELTA_LOG_FILE
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
    TEMP_PATTERN_CONF_FILE="/tmp/temp_dcafile.conf"
    MAP_PATTERN_CONF_FILE="/tmp/temp_mapfile.conf"
    
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
    
    rm -f $MAP_PATTERN_CONF_FILE
    rm -f $TEMP_PATTERN_CONF_FILE

}

# Reschedule the cron based on diagnositic mode
if [ $triggerType -eq 3 ] ; then
	echo_t "$timestamp: dca: Processing rescheduleCron job" >> $RTL_LOG_FILE
    scheduleCron
    ## Telemetry must be invoked only for reschedule cron job
    pidCleanup
    exit 0
fi

# Regenerate config only during boot-up and when there is an update
if [ ! -f $SORTED_PATTERN_CONF_FILE ] || [ $triggerType -eq 1 ] ; then
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
            if [ ! -f $PEER_COMM_ID ]; then
                GetConfigFile $PEER_COMM_ID
            fi
            scp -i $PEER_COMM_ID -r $ARM_INTERFACE_IP:$DCMRESPONSE $DCMRESPONSE > /dev/null 2>&1
            sleep 10
        done
    fi
    processJsonResponse "$DCMRESPONSE"
    clearTelemetryConfig
    generateTelemetryConfig $TELEMETRY_PROFILE_PATH $SORTED_PATTERN_CONF_FILE
    scheduleCron
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
    if [ ! -f $PEER_COMM_ID ]; then
        GetConfigFile $PEER_COMM_ID
    fi
    scp -i $PEER_COMM_ID -r $ARM_INTERFACE_IP:$LOG_PATH/* $TMP_SCP_PATH/ > /dev/null 2>&1
    scp -i $PEER_COMM_ID -r $ARM_INTERFACE_IP:$LOG_SYNC_PATH/$SelfHealBootUpLogFile  $ARM_INTERFACE_IP:$LOG_SYNC_PATH/$PcdLogFile  $TMP_SCP_PATH/ > /dev/null 2>&1

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
    dcaOutputJson=`nice -n 19 $DCA_BINARY $SORTED_PATTERN_CONF_FILE 2>> $RTL_LOG_FILE`
    if [ -z "$dcaOutputJson" ];
    then
      dcaOutputJson=$defaultOutputJSON
    fi

    singleEntry=true


       ## This interface is not accessible from ATOM, replace value from ARM
       estbMac=$(getEstbMac)
       firmwareVersion=$(getFWVersion)
       firmwareVersion=$(echo $firmwareVersion | sed -e "s/imagename://g")
       partnerId=$(getPartnerId)
       accountId=$(getAccountId)
       erouterIpv4=$(getErouterIpv4)
       erouterIpv6=$(getErouterIpv6)

       cur_time=`date "+%Y-%m-%d %H:%M:%S"`
     
       if $singleEntry ; then
            outputJson="$outputJson{\"Profile\":\"RDKB\"},{\"mac\":\"$estbMac\"},{\"erouterIpv4\":\"$erouterIpv4\"},{\"erouterIpv6\":\"$erouterIpv6\"},{\"PartnerId\":\"$partnerId\"},{\"AccountId\":\"$accountId\"},{\"Version\":\"$firmwareVersion\"},{\"Time\":\"$cur_time\"}"
            singleEntry=false
       else
            outputJson="$outputJson,{\"Profile\":\"RDKB\"},{\"mac\":\"$estbMac\"},{\"erouterIpv4\":\"$erouterIpv4\"},{\"erouterIpv6\":\"$erouterIpv6\"},{\"PartnerId\":\"$partnerId\"},{\"AccountId\":\"$accountId\"},{\"Version\":\"$firmwareVersion\"},{\"Time\":\"$cur_time\"}"
       fi

       remain="{\"<remaining_keys>\":\"<remaining_values>\"}"
       outputJson=`echo "$dcaOutputJson" | sed "s/$remain/$outputJson/"`
       
       outputJson=`echo "$outputJson" | sed -r 's/(\":\")\s*/\1/g'`

       echo $outputJson >> $RTL_LOG_FILE
       echo "$outputJson" > $TELEMETRY_JSON_RESPONSE
       sleep 2

       if [ "x$DCA_MULTI_CORE_SUPPORTED" = "xyes" ]; then
           echo "Notify ARM to pick the updated JSON message in $TELEMETRY_JSON_RESPONSE and upload to splunk" >> $RTL_LOG_FILE
           # Trigger inotify event on ARM to upload message to splunk
           if [ $triggerType -eq 2 ]; then
               sshCmdOnArm 'notifyFlushLogs'
               echo_t "notify ARM for dca execution completion" >> $RTL_LOG_FILE
           else
               if [ "$bootupTelemetryBackup" = "true" -a $triggerType -eq 1 ];then
                    sshCmdOnArm 'bootupBackup'
               else
                    sshCmdOnArm 'splunkUpload'
               fi
           fi
       else
           if [ $triggerType -eq 2 ]; then
               touch $TELEMETRY_EXEC_COMPLETE
           fi
           sh /lib/rdk/dcaSplunkUpload.sh &
       fi
fi

if [ -f $RTL_DELTA_LOG_FILE ]; then
    rm -f $RTL_DELTA_LOG_FILE
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

echo "$dcaNexecCounter" > $EXEC_COUNTER_FILE
# PID file cleanup
pidCleanup
