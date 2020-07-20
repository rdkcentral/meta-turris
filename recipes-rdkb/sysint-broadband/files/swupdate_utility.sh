#!/bin/bash
. /etc/include.properties
. /etc/device.properties

#Utility Functions
#=================

check ()
{
 if [ $? != 0 ]; then
    echo "FATAL: $*"
    sleep 10
    continue
 fi
}

jsonparse() {
 if [ -d $1 ]; then
    printf "Usage 'jsonparse <parameter-name>'\n"
    exit 1
 fi
 value=`cat /tmp/cloudurl.txt | json_reformat | grep -w $1 | cut -d':' -f2 | tr -d "\",\ "`
 if [ -d $value ];then
   echo "FATAL: JSON value not present, check /tmp/cloudurl.txt file"
   exit 1
 fi
 echo $value
}

tftpDownload () {
 mkdir -p /tmp/tftpimage
 cd /tmp/tftpimage
 echo "set IPtable rules for tftp !!"
 iptables -t raw -I OUTPUT -j CT -p udp -m udp --dport 69 --helper tftp
 echo "CloudFile: "$firmwareFilename
 echo "CloudLocation: "$firmwareLocation

 check_sum_file="${firmwareVersion}.txt"
 echo "Checksum file to download from tftp server: $check_sum_file"
 tftp -g  -r $check_sum_file $firmwareLocation
 if [ ! -f $PWD/$check_sum_file ]; then
    echo "Cloud checksum file not downloaded from TFTP: verify tftp connection($firmwareLocation)"
    sleep 2
    continue
 fi

 echo "Downloading $firmwareFilename..."
 tftp -g  -r $firmwareFilename $firmwareLocation
 if [ ! -f $PWD/$firmwareFilename ]; then
    echo "Image itself not downloaded from TFTP: verify tftp connection($firmwareLocation)"
    sleep 2
    continue
 fi
 echo "Doing additional check: comparing checksum ..."
 cloudcsfile_path="/tmp/tftpimage/$check_sum_file"
 echo "checksum file to download with actual path: $cloudcsfile_path"
 cloudcs=`cat $cloudcsfile_path | cut -f 1 -d ' '`
 echo "cloudcs:cloud download md5sum file version: $cloudcs"
 devcs=`md5sum /tmp/tftpimage/rdk*.tar | cut -f 1 -d " "`
 echo "devcs:image download checksum md5sum file version: $devcs"

 if [ "$devcs" != "$cloudcs" ]; then
    echo "Mismatch in md5sum: tftp file not downloaded properly"
    continue
 fi
 echo "checksum verification done: md5sum matches !!"
 tar -xf /tmp/tftpimage/$firmwareVersion.tar -C /tmp/
 check "Failed to untar $firmwareFilename"
}

httpDownload () {
 mkdir -p /tmp/httpimage
 cd /tmp/httpimage
 echo "CloudFile: "$firmwareFilename
 echo "CloudLocation: "$firmwareLocation

 check_sum_file="${firmwareVersion}.txt"
 echo "Checksum file to download from webserver: $check_sum_file"
 wget http://$firmwareLocation/$check_sum_file -O $check_sum_file
 if [ ! -f $PWD/$check_sum_file ]; then
    echo "Cloud checksum file not downloaded from Webserver: verify connection to $firmwareLocation"
    sleep 2
    continue
 fi

 echo "Downloading $firmwareFilename..."
 wget http://$firmwareLocation/$firmwareFilename -O $firmwareFilename
 if [ ! -f $PWD/$firmwareFilename ]; then
    echo "Image itself not downloaded from Webserver: verify connection to $firmwareLocation"
    sleep 2
    continue
 fi
 echo "Doing additional check: comparing checksum ..."
 cloudcsfile_path="/tmp/httpimage/$check_sum_file"
 echo "checksum file to download with actual path: $cloudcsfile_path"
 cloudcs=`cat $cloudcsfile_path | cut -f 1 -d ' '`
 echo "cloudcs:cloud download md5sum file version: $cloudcs"
 devcs=`md5sum /tmp/httpimage/rdk*.tar | cut -f 1 -d " "`
 echo "devcs:image download checksum md5sum file version: $devcs"

 if [ "$devcs" != "$cloudcs" ]; then
    echo "Mismatch in md5sum: http file not downloaded properly"
    continue
 fi
 echo "checksum verification done: md5sum matches !!"
 tar -xf /tmp/httpimage/$firmwareVersion.tar -C /tmp/
 check "Failed to untar $firmwareFilename"
}

download_image() {
   if [ $firmwareDownloadProtocol == "tftp" ]; then
      tftpDownload
   elif [ $firmwareDownloadProtocol == "http" ]; then
      httpDownload
   else
      echo "Unknown protocol"
   fi
}

echo "***Start of swupdate_utility.sh***"

rebootRequired=false
while [ 1 ]
do
if [ $rebootRequired == true ];then
   echo "Reboot Pending: reboot is required before possible firmware upgrade"
   sleep 10
   continue
fi
#Getting update from cloud
#=========================

CLOUDURL=http://35.155.171.121:9092/xconf/swu/stb?eStbMac=
erouterMac=`ifconfig $EROUTER_INTERFACE | grep HWaddr | cut -c39-55`
CLOUD_URL=$CLOUDURL$erouterMac

echo "CLOUD_URL: $CLOUD_URL"
curl $CLOUD_URL  -o /tmp/cloudurl.txt
if [ $? != 0 ];then
   echo "curl failed to fetch firmware details: check internet connection"
   sleep 10
   continue
fi

#version check
#=============

#Comparing image versions and will upgrade if there is a mismatch
currentVersion=`grep "^imagename" /version.txt | cut -d ':' -f2`

#eg. firmwareVersion=rdkb-generic-broadband-image_default_20200608060354
firmwareVersion=`jsonparse firmwareVersion`
cloudfirmwareversion=$firmwareVersion
if [ "$currentVersion" == "$cloudfirmwareversion" ]; then
   echo "Image versions remains same !!"
   sleep 10
   continue
fi

echo "cloud Image version: "$cloudfirmwareversion
echo "Current Image version: "$currentVersion
echo "Image versions mismatches !! start upgrade"

#Environment setting
#===================
#eg. firmwareDownloadProtocol=tftp
firmwareDownloadProtocol=`jsonparse firmwareDownloadProtocol`

#eg. firmwareFilename=rdkb-generic-broadband-image_default_20200608060354.tar
firmwareFilename=`jsonparse firmwareFilename`

#eg. firmwareLocation=192.168.1.9
firmwareLocation=`jsonparse firmwareLocation`

#eg. rebootImmediately=false
rebootImmediately=`jsonparse rebootImmediately`

download_image
/lib/rdk/TurrisFwUpgrade.sh
check "TurrisFwUpgrade.sh failed to flash new Image"

if [ $rebootImmediately == true ]; then
   reboot
fi
rebootRequired=true
done
