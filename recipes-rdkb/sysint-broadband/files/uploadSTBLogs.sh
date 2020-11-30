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

. $RDK_PATH/utils.sh 
. $RDK_PATH/interfaceCalls.sh
. $RDK_PATH/utils.sh
. $RDK_PATH/logfiles.sh
. $RDK_PATH/commonUtils.sh

if [ $# -ne 6 ]; then 
     echo "USAGE: $0 <TFTP Server IP> <Flag (STB delay or not)> <SCP_SERVER> <UploadOnReboot> <UploadProtocol> <UploadHttpLink>"
fi

# assign the input arguments
TFTP_SERVER=$1
FLAG=$2
DCM_FLAG=$3
UploadOnReboot=$4
UploadProtocol=$5
UploadHttpLink=$6

DCM_LOG_PATH=/upload

if [ $FLAG -eq 0 ]; then
     if [ -f $RAMDISK_PATH/.standby ]; then
          echo "`/bin/timestamp` Exiting since box is in standby..!"
          exit 0
     fi
fi

# initialize the variables
MAC=`getErouterMacAddress`
HOST_IP=`getIPAddress`
dt=`date "+%m-%d-%y-%I-%M%p"`
LOG_FILE="$MAC_Logs_$dt.tgz"

#MARKER_FILE=$MAC"_Logs_Marker_$dt.txt"
VERSION="version.txt"
# working folders
PREV_LOG_PATH="$LOG_PATH/PreviousLogs"
PREV_LOG_BACKUP_PATH="$LOG_PATH/PreviousLogs_backup/"
DCM_UPLOAD_LIST="$LOG_PATH/dcm_upload"

echo "Build Type: $BUILD_TYPE Log file: $LOG_FILE TFTP Server: $TFTP_SERVER Protocol: $UploadProtocol UploadHttpLink: $UploadHttpLink" >> $LOG_PATH/dcmscript.log

prevUploadFlag=0

if [ ! -d $PREV_LOG_PATH ]; then
      echo "The Previous Logs folder is missing" >> $LOG_PATH/dcmscript.log
      #if [ "true" != "$RDK_EMULATOR" ]; then
      #	    exit 0
      #else

    	if [ ! -d $LOG_PATH ]; then mkdir -p $LOG_PATH; fi
   	if [ ! -d $LOG_PATH/PreviousLogs ]; then mkdir -p $LOG_PATH/PreviousLogs; fi
    	if [ ! -d $LOG_PATH/PreviousLogs_backup ]; then mkdir -p $LOG_PATH/PreviousLogs_backup; fi
    	rm -rf $LOG_PATH/PreviousLogs_backup/*

	backupSystemLogFiles mv $LOG_PATH $PREV_LOG_PATH
        backupAppBackupLogFiles mv $LOG_PATH $PREV_LOG_PATH

      #fi
else
     #if [ "true"  !=  "$RDK_EMULATOR" ]; then
	#echo ""
     #else

    	rm -rf $LOG_PATH/PreviousLogs_backup/*
	backupSystemLogFiles mv $LOG_PATH $PREV_LOG_PATH
        backupAppBackupLogFiles mv $LOG_PATH $PREV_LOG_PATH
     	#cp $PREV_LOG_BACKUP_PATH/* $PREV_LOG_PATH/
     #fi
fi

backupAppLogs()                                                        
{                                                               
    source=$1                                                   
    destn=$2                                                    
    if [ -f $source$RILog ] ; then cp $source$RILog $destn; fi  
    if [ -f $source$XRELog ] ; then cp $source$XRELog $destn; fi
    if [ -f $source$WBLog ] ; then cp $source$WBLog $destn; fi  
    if [ -f $source$SysLog ] ; then cp $source$SysLog $destn; fi
}  
renameRotatedLogs()
{
    logPath=$1
    if [ -f $RDK_PATH/renameRotatedLogs.sh ]; then
         if [ -f $logPath/ocapri_log.txt ] ; then sh $RDK_PATH/renameRotatedLogs.sh $logPath/ocapri_log.txt; fi
         if [ -f $logPath/receiver.log ] ; then sh $RDK_PATH/renameRotatedLogs.sh $logPath/receiver.log; fi
         if [ -f $logPath/greenpeak.log ] ; then sh $RDK_PATH/renameRotatedLogs.sh $logPath/greenpeak.log; fi
         if [ -f $logPath/gp_init.log ] ; then sh $RDK_PATH/renameRotatedLogs.sh $logPath/gp_init.log; fi
         if [ -f $logPath/app_status.log ] ; then sh $RDK_PATH/renameRotatedLogs.sh $logPath/app_status.log; fi
    fi
}
processLogsFolder()
{
    srcLogPath=$1
    destnLogPath=$2
    backupAppLogs "$srcLogPath/" "$destnLogPath/"
    backupSystemLogFiles "cp" $srcLogPath $destnLogPath
    backupAppBackupLogFiles "cp" $srcLogPath $destnLogPath

    if [ -f $RAMDISK_PATH/disk_log.txt ]; then cp $RAMDISK_PATH/disk_log.txt $destnLogPath ; fi

    backupCount=`ls $srcLogPath/logbackup-* 2>/dev/null | wc -l`
    if [ $backupCount -gt 0 ]; then
 	cp -r $srcLogPath/logbackup-* $destnLogPath
    fi

    if [ -f $srcLogPath/$rebootLog ]; then cp $srcLogPath/$rebootLog $destnLogPath; fi
    if [ -f $srcLogPath/$ablReasonLog ]; then cp $srcLogPath/$ablReasonLog $destnLogPath; fi
    if [ -f $srcLogPath/$ueiLog ]; then cp $srcLogPath/$ueiLog $destnLogPath; fi
    if [ -f $PERSISTENT_PATH/sventest/p3541_all_csven_AV_health_data_trigger.tar.gz ] ; then
        cp $PERSISTENT_PATH/sventest/p3541_all_csven_AV_health_data_trigger.tar.gz $destnLogPath
    fi
    if [ "$DEVICE_TYPE" != "mediaclient" ]; then
          renameRotatedLogs $srcLogPath
    fi
}
modifyFileWithTimestamp()
{
    srcLogPath=$1
    ret=`ls $srcLogPath/*.txt | wc -l`
    if [ ! $ret ]; then 
         ret=`ls $srcLogPath/*.log | wc -l`
         if [ ! $ret ]; then exit 1; fi
    fi

    dt=`date "+%m-%d-%y-%I-%M%p-"`
    FILES=*.*
    FILES1=".*-[0-9][0-9]AM-.*"
    FILES2=".*-[0-9][0-9]PM-.*"

    for f in $FILES
    do
        test1=0
        test2=0
        test3=0
        test4=0

        test1=`expr match $f $FILES1`
        test2=`expr match $f $FILES2`
        test3=`expr match $f $rebootLog`
        test4=`expr match $f $ablReasonLog`

        if [ $test1 -gt 0 -o $test2 -gt 0 -o $test3 -gt 0 -o $test4 -gt 0 ];  then
            echo "`/bin/timestamp` Processing file...$f"  >> $LOG_PATH/dcmscript.log
        else
            mv $f $dt$f
        fi
    done
    #cp /version.txt ./$dt$VERSION
}

copyAllFiles ()
{
	  
		EXCLUDE="dcm PreviousLogs_backup PreviousLogs"
		cd $LOG_PATH

		for fileName in *
		do
			COPY_BOOLEAN=true
			for excl in $EXCLUDE
			do  
				if [ $excl == $fileName ]; then
					COPY_BOOLEAN=false
				fi  
			done
	
		if $COPY_BOOLEAN; then	
			cp -R $fileName $DCM_LOG_PATH
		fi
		done
}
copyOptLogsFiles ()
{
   cd $LOG_PATH
   cp  * $DCM_LOG_PATH >> $LOG_PATH/dcmscript.log  2>&1
}
 
HttpLogUpload()
{
    result=1
    FILENAME='/tmp/httpresult.txt'
    HTTP_CODE=/tmp/curl_httpcode

    CLOUD_URL=$UploadHttpLink
    #CLOUD_URL="$(UploadHttpLink)filename=$LOG_FILE"
    
    CURL_CMD="curl -w '%{http_code}\n' -F \"filename=@$1\" -o \"$FILENAME\" \"$CLOUD_URL\" --connect-timeout 10 -m 10"
    echo URL_CMD: $CURL_CMD
    ret= eval $CURL_CMD > $HTTP_CODE
    http_code=$(awk -F\" '{print $1}' $HTTP_CODE)
    if [ $http_code -eq 200 ];then
        echo "`/timestamp` Done Uploading Logs through HTTP" >> $LOG_PATH/dcmscript.log
        result=0
    elif [ $http_code -eq 302 ];then
        #Get the url from FILENAME
        NewUrl=$(awk -F\" '{print $1}' $FILENAME)
        
        CURL_CMD="curl -w '%{http_code}\n' -o \"$FILENAME\" \"$NewUrl\" --connect-timeout 10 -m 10"
        echo URL_CMD: $CURL_CMD        
        result= eval $CURL_CMD > $HTTP_CODE
        http_code=$(awk -F\" '{print $1}' $HTTP_CODE)
        
        if [ $http_code -eq 200 ];then
            echo "`/timestamp` Done Uploading Logs through - HTTP" >> $LOG_PATH/dcmscript.log
            result=0
        else
          	 echo "`/timestamp` Failed Uploading Logs through - HTTP" >> $LOG_PATH/dcmscript.log
        fi
    fi    
    echo $result
}

uploadDCMLogs()
{

   cd $DCM_LOG_PATH
   echo " Uploading Logs through DCM cron job" >> $LOG_PATH/dcmscript.log
   modifyFileWithTimestamp $DCM_LOG_PATH >> $LOG_PATH/dcmscript.log  2>&1
   tar -zcvf $LOG_FILE * >> $LOG_PATH/dcmscript.log  2>&1
   sleep 60
   echo "Uploading logs $LOG_FILE  onto $TFTP_SERVER" >> $LOG_PATH/dcmscript.log   
   
   retval=1
   
    if [ "$UploadProtocol" == "HTTP" ];then
		retval=$(HttpLogUpload $LOG_FILE)
	fi
	if [ $retval -eq 1 ];then #Http upload failed
		tftp -p -r $LOG_FILE -l $LOG_FILE $TFTP_SERVER >> $LOG_PATH/dcmscript.log 2>&1
		echo "`/bin/timestamp` Done Uploading Logs through TFTP" >> $LOG_PATH/dcmscript.log
		sleep 1
	fi

     rm -rf $DCM_LOG_PATH/	
}
uploadLogOnReboot()
{
	uploadLog=$1
	echo "Sleeping for seven minutes "
	if [ "true" != "$RDK_EMULATOR" ]; then
	sleep 12
	fi
	echo "Done sleeping prev logpath "$PREV_LOG_PATH
    ret=`ls $PREV_LOG_PATH/*.txt | wc -l`
    if [ ! $ret ]; then 
         ret=`ls $PREV_LOG_PATH/*.log | wc -l` 
         if [ ! $ret ]; then exit 1; fi
    fi
    if [ "$HDD_ENABLED" = "true" ]; then
        # Special processing - Permanently backup logs on box delete the logs older than 
        # 3 days to take care of old filename
	sleep 2
        stat=`find /opt/logs -name "*-*-*-*-*M-" -mtime +3 -exec rm -rf {} \;`
        # for the new filenames with suffix logbackup
        stat=`find /opt/logs -name "*-*-*-*-*M-logbackup" -mtime +3 -exec rm -rf {} \;`

        TIMESTAMP=`date "+%m-%d-%y-%I-%M%p-logbackup"`                   
        PERM_LOG_PATH="$LOG_PATH/$TIMESTAMP"                                
        mkdir -p $PERM_LOG_PATH                                             

        processLogsFolder $PREV_LOG_PATH $PERM_LOG_PATH	
     fi
    echo "ckp100-------------prev log path-------------"$PREV_LOG_PATH
    cd $PREV_LOG_PATH
    rm $LOG_FILE
    modifyFileWithTimestamp $PREV_LOG_PATH >> $LOG_PATH/dcmscript.log  2>&1

    echo "ckp101---------------------upload log-----"$uploadLog
    ls  -al
    sleep 30
	if $uploadLog; then
            echo "ckp101--------------------------"
	    tar -zcvf $LOG_FILE * >> $LOG_PATH/dcmscript.log  2>&1
		echo "Uploading logs $LOG_FILE  onto $TFTP_SERVER" >> $LOG_PATH/dcmscript.log
		sleep 60
		#tftp -p  -r $LOG_FILE -l $LOG_FILE $TFTP_SERVER >> $LOG_PATH/dcmscript.log 2>&1
		#sleep 1
		#echo "`/bin/timestamp` Done Uploading Logs" >> $LOG_PATH/dcmscript.log 
                proUpdel=`cat /tmp/DCMSettings.conf | grep -i uploadRepository:uploadProtocol | tr -dc '"' |wc -c`
                echo "number of proUPdel2:"$proUpdel
                #proUpdel=$((proUpdel - 1))
                uploadProtocolla=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d '"' -f$proUpdel`
                echo "Upload protocol logupload is:"$uploadProtocolla
                TurrisMacAddress=`ifconfig erouter0 | grep HWaddr | cut -c39-55`
                cp $LOG_FILE $TurrisMacAddress-Logs-$LOG_FILE
		 if [ "$uploadProtocolla" != "TFTP" ];then
                     echo "before HTTP log upload"
		     HTTPLOGUPLOADURL=`cat /tmp/DCMSettings.conf | grep -i "urn:settings:LogUploadSettings:RepositoryURL" | cut -d "=" -f2`
                     if [ "$HTTPLOGUPLOADURL" == "" ]; then
                         echo "No HTTP URL configured in xconf,going with internal one !!"
                         HTTPLOGUPLOADURL=$DCM_LA_SERVER_URL
                     fi
                     echo "HTTPLOGUPLOADURL:"$HTTPLOGUPLOADURL
                     echo "upload log file is:"$LOG_FILE
                     CURL_CMD="curl -w '%{http_code}\n' -F filename=@$PREV_LOG_PATH/$TurrisMacAddress-Logs-$LOG_FILE '$HTTPLOGUPLOADURL' --connect-timeout 100 -m 100"
                     #echo_t "CURL_CMD http proto log upload: $CURL_CMD" >> $DCM_LOG_FILE
                     echo "------CURL_CMD2:"$CURL_CMD
                     HTTP_CODE=`result= eval $CURL_CMD`
                     http_code=$(echo $HTTP_CODE | cut -d "." -f 2)
                     echo "http_code is :"$http_code
                     if [ $http_code -eq 200 ] ; then
                         echo "HTTP log upload succeded!!!!!!!!!!!!!!!!!"
                     else
                         loguploadRetryCount=0
                         while [ $loguploadRetryCount -lt 2 ]
                         do
                             echo "Trying to upload log file..."
                             CURL_CMD="curl -w '%{http_code}\n' -F filename=@$PREV_LOG_PATH/$TurrisMacAddress-Logs-$LOG_FILE '$HTTPLOGUPLOADURL' --connect-timeout 100 -m 100"
                             HTTP_CODE=`result= eval $CURL_CMD`
                             http_code_la=$(echo $HTTP_CODE | cut -d "." -f 2)
                             echo "http_code is :"$http_code_la
                             if [ "$http_code_la" != "200" ]; then
                                   echo "Error in uploading log file"
                             else
                                   echo "logupload succeded in retry"
                                   break
                             fi
                             loguploadRetryCount=`expr $loguploadRetryCount + 1`
                         done
                             if [ $loguploadRetryCount -eq 2]; then
                                 echo "HTTP log upload failed!!!!!!!!!!!!!!!!!"
                             fi
                      fi
                else
                        echo "Uploading logs $LOG_FILE  onto $TFTP_SERVER" >> $LOG_PATH/dcmscript.log
                        tftp -p  -r $TurrisMacAddress-Logs-$LOG_FILE -l $TurrisMacAddress-Logs-$LOG_FILE $TFTP_SERVER >> $LOG_PATH/dcmscript.log 2>&1
                        ret=$?
                        echo $ret
                        if [ "$ret" -eq 1 ]; then
                             tftplauploadRetryCount=0
                             while [ "$tftplauploadRetryCount" -lt 2 ]
                             do
                                echo "Trying to upload logs file using tftp again..."
                                tftp -p  -r $TurrisMacAddress-Logs-$LOG_FILE -l $TurrisMacAddress-Logs-$LOG_FILE $TFTP_SERVER >> $LOG_PATH/dcmscript.log 2>&1
                                ret=$?
                                if [ "$ret" -eq 1 ]; then
                                     echo "error in uploading logs using tftp"
                                else
                                     echo "tftp upload in retry logs succeded"
                                     ret=0
                                     break
                                fi
                                tftplauploadRetryCount=`expr $tftplauploadRetryCount + 1`
                             done
                             if [ "$tftlauploadRetryCount" -eq 2 ]; then
                                ret=1
                                echo "TFTP log  upload failed!!!!!!!!!!!!!!!!!"
                             else
                                echo "TFTP log upload succeded !!!"
                                ret=0
                             fi
                       fi
                 fi
                sleep 60
                echo "Done Uploading Logs and removing rtl_json.txt file"
                rm -rf $PREV_LOG_PATH/$TurrisMacAddress-Logs-$LOG_FILE
                rm -rf $TELEMETRY_JSON_RESPONSE
                rm -rf $PERSISTENT_PATH/*TELE*
	fi
	cd $PREV_LOG_PATH
    rm -rf $PREV_LOG_PATH/$LOG_FILE
    rm -rf  $PREV_LOG_BACKUP_PATH
    mkdir -p $PREV_LOG_BACKUP_PATH
	if [ "$BUILD_TYPE" = "dev" ] || [ "$HDD_ENABLED" = "false" ]; then
	
		echo "Moving to Previous Logs Backup Folder " >> $LOG_PATH/dcmscript.log
		mv * $PREV_LOG_BACKUP_PATH
	else
		echo "`/bin/timestamp` Deleting from Previous Logs  Folder " >> $LOG_PATH/dcmscript.log
		rm -rf *
	fi	
}
#if [ "$true" != "$RDK_EMULATOR" ]; then
#if [ -d $DCM_LOG_PATH ]; then
 #    rm -rf $DCM_LOG_PATH/
#fi
#Remove *.tgz files from /opt/logs
#if [ "true" != "$RDK_EMULATOR" ]; then
#stat=`find $LOG_PATH -name "*.tgz" -exec rm -rf {} \;`

#Remove files which have timestamp in it filename
#for item in `ls $LOG_PATH/*-*-*-*-*M-* | grep "[0-9]*-[0-9]*-[0-9]*-[0-9]*-M*" | grep -v "logbackup"`;do
 #   if [ -f "$item" ];then
  #      echo "`/bin/timestamp` Removing $item" >> $LOG_PATH/dcmscript.log
   #     rm -rf $item
    #fi
#done
#fi
#fi
if [ $DCM_FLAG -eq 0 ] ; then 
     echo "`/bin/timestamp`  Uploading Without DCM" >> $LOG_PATH/dcmscript.log
	 uploadLogOnReboot true
else 
     if [ $FLAG -eq 1 ] ; then 
	      if [ $UploadOnReboot -eq 1 ]; then	
				echo "Uploading Logs with DCM UploadOnReboot set to true" >> $LOG_PATH/dcmscript.log
				echo "call uploadLogOnReboot"
				uploadLogOnReboot true	
		   
		  else 
				echo "`/bin/timestamp` Not Uploading Logs with DCM UploadOnReboot set to false" >> $LOG_PATH/dcmscript.log
				uploadLogOnReboot false
				echo $PERM_LOG_PATH >> $DCM_UPLOAD_LIST
		  fi
		
	 else
	      if [ $UploadOnReboot -eq 0 ]; then  
	             mkdir -p $DCM_LOG_PATH
                 if [ "$HDD_ENABLED" = "true" ]; then
                      fileUploadCount=`cat "$DCM_UPLOAD_LIST" | wc -l`
	                  if [ $fileUploadCount -gt 0 ]; then
	   		     	       while read line
				           do
					          echo $line 								
					          cp -R $line $DCM_LOG_PATH
		     	           done < $DCM_UPLOAD_LIST
		 		           copyOptLogsFiles		 
		 		           cat /dev/null > $DCM_UPLOAD_LIST		  
		 		           uploadDCMLogs
			          else	
				           copyOptLogsFiles		 
		     		       uploadDCMLogs		  
			          fi
                 else
				     if [ -f $PREV_LOG_BACKUP_PATH/uploaded ]; then
					      copyOptLogsFiles
					      uploadDCMLogs
				     else 
					      cd $PREV_LOG_BACKUP_PATH
					      foldertime=`ls *version.txt | cut -c 1-16`
                          if [ -z $foldertime ]; then
                               foldertime=`date +%m-%d-%y-%I-%M%p`
                          fi
					      TIMESTAMP=$foldertime-logbackup
					      PERM_LOG_PATH="/mnt/memory/dcm/$TIMESTAMP" 
					      mkdir -p $PERM_LOG_PATH 
					      cp * $PERM_LOG_PATH
					      copyOptLogsFiles
					      uploadDCMLogs
					      cd $PREV_LOG_BACKUP_PATH
					      touch uploaded
				     fi
                 fi
  
		   else 
                if [ "$HDD_ENABLED" = "true" ]; then
       			     touch $DCM_INDEX
       			     copyAllFiles
     			     uploadDCMLogs
                fi
	       fi
	   fi
fi 

