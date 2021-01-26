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

#RDK-B LOGS
BootTimeLog="BootTime.log"
BootTimeLogBackup="BootTime.log.*"
speedtestLog="speedtest.log"
speedtestLogBackup="speedtest.log.*"
ArmConsolelog="ArmConsolelog.txt.0"
ArmConsolelogBackup="ArmConsolelog.txt.*"
Consolelog="Consolelog.txt.0"
ConsolelogBackup="Consolelog.txt.*"
LMlog="LM.txt.0"
LMlogBackup="LM.txt.*"
PAMlog="PAMlog.txt.0"
PAMlogBackup="PAMlog.txt.*"
PARODUSlog="PARODUSlog.txt.0"
PARODUSlogBackup="PARODUSlog.txt.*"
PSMlog="PSMlog.txt.0"
PSMlogBackup="PSMlog.txt.*"
TDMlog="TDMlog.txt.0"
TDMlogBackup="TDMlog.txt.*"
TR69log="TR69log.txt.0"
TR69logBackup="TR69log.txt.*"
WEBPAlog="WEBPAlog.txt.0"
WEBPAlogBackup="WEBPAlog.txt.*"
WiFilog="WiFilog.txt.0"
WiFilogBackup="WiFilog.txt.*"
FirewallDebug="FirewallDebug.txt"
FirewallDebugBackup="FirewallDebug.txt.*"
MnetDebug="MnetDebug.txt"
MnetDebugBackup="MnetDebug.txt.*"
wifihealthlog="wifihealth.txt"
wifihealthBackup="wifihealth.txt.*"
CRLog="CRlog.txt.0"
CRLogBackup="CRlog.txt.*"

xreLog="receiver.log"
cecLog="cec_log.txt"
cecLogsBackup="cec_log.txt.*"
xreLogsBackup="receiver.log.*"
receiverMON="ReceiverMON.txt"
runXreLog="runXRE_log.txt"
runXreLogsBackup="runXRE_log.txt.*"
greenpeakLog="greenpeak.log"
greenpeakLogsBackup="greenpeak.log.*"
appStatusLog="app_status.log"
appStatusLogsBackup="app_status.log.*"
gpInitLog="gp_init.log"
gpInitLogsBackup="gp_init.log.*"
#demsg Logs
dmesgLog="messages_printk.txt"
dmesgLogsBackup="messages_printk_bak*"
sysLog="messages.txt"
ntpLog="ntp.log"
sysLogsBackup="messages.txt.*"
ntpLogsBackup="ntp.log.*"
sysDmesgLog="messages-dmesg.txt"
sysDmesgLogsBackup="messages-dmesg.txt.*"
startupDmesgLog="startup_stdout_log.txt"
startupDmesgLogsBackup="startup_stdout_log.*"
lighttpdErrorLog="lighttpd.error.log"
lighttpdErrorLogsBackup="lighttpd.error.log.*"
lighttpdAccessLog="lighttpd.access.log"
lighttpdAccessLogsBackup="lighttpd.access.log.*"
dcmLog="dcmscript.log"
dcmLogsBackup="dcmscript.log.*"
uiLog="uimgr_log.txt"
uiLogsBackup="uimgr_log.txt.*"
storagemgrLog="storagemgr.log"
storagemgrLogsBackup="storagemgr.log.*"
rf4ceLog="rf4ce_log.txt"
rf4ceLogsBackup="rf4ce_log.txt.*"
ctrlmLog="ctrlm_log.txt"
ctrlmLogsBackup="ctrlm_log.txt.*"
xDiscoveryLog="xdiscovery.log"
xDiscoveryLogsBackup="xdiscovery.log.*"
xDiscoveryListLog="xdiscoverylist.log"
xDiscoveryListLogsBackup="xdiscoverylist.log.*"
hdmiLog="hdmi_log.txt"
rebootLog="reboot.log"
rebootInfoLog="rebootInfo.log"
ueiLog="uei_init.log"
wbLog="wbdevice.log"
swUpdateLog="swupdate.log"
topLog="top_log.txt"
topLogsBackup="top_log.txt.*"
mocaLog="mocalog.txt"
coreLog="coredump.log"
coreDumpLog="core_log.txt"
coreDumpLogsBackup="core_log.txt.*"
version="version.txt"
fusionDaleLog="fusiondale_log.txt"
socProvisionLog="socprov.log"
socProvisionLogsBackup="socprov.log.*"
socProvisionCryptoLog="socprov-crypto.log"
socProvisionCryptoLogsBackup="socprov-crypto.log.*"
applicationsLog="applications.log"
applicationsLogsBackup="applications.log.*"
systemLog="system.log"
systemLogsBackup="system.log.*"
bootUpLog="bootlog"
resetLog="Reset.txt"
resetLogsBackup="Reset.txt"
backUpDumpLog="backupCoreDumpLog.txt"
gpLog="gp.log"
gpLogsBackup="gp.log.*"
diskInfoLog="diskInfo.txt"
diskEventsLog="diskEvents.txt"

rmfLog="rmfstr_log.txt"
rmfLogsBackup="rmfstr_log.txt.*"
podLog="pod_log.txt"
podLogsBackup="pod_log.txt.*"
vodLog="vodclient_log.txt"
vodLogsBackup="vodclient_log.txt.*"
rstreamFdLog="rstreamer_fdlist.txt"

recorderLog="/opt/rec_debug.log"
fdsLog="fds.log"
fdsLogsBackup="fds.log.*"
trmLog="trm.log"
trmMgrLog="trmmgr.log"
trmLogsBackup="trm.log.*"
trmMgrLogsBackup="trmmgr.log.*"
threadLog="vlthreadanalyzer_log.txt"
threadLogsBackup="vlthreadanalyzer_log.txt.*"
xDeviceLog="xdevice.log"
xDeviceLogsBackup="xdevice.log.*"
authServiceLog="authservice.log"
cardProvisionCheckLog="card-provision-check.log"
ipdnlLog="ipdllogfile.txt"
diskCleanupInfoLog="disk_cleanup_info.log"
topOsalLog="top_osal.txt"
topOsalLogsBackup="top_osal.txt.*"
mocaStatusLog="mocaStatus.log"
mocaStatusLogsBackup="mocaStatus.log.*"
mfrLog="mfrlib_log.txt"
mfrLogsBackup="mfrlib_log.txt.*"
mfrLogRdk="mfr_log.txt"
mfrLogsRdkBackup="mfr_log.txt.*"
adobeCleanupLog="cleanAdobe.log"

cefLog="cef.log"
cefLogsBackup="cef.log.*"
diskCleanupLog="disk_cleanup.log"
diskCleanupLog1="disk_cleanup.log"
diskCleanupLogsBackup="disk_cleanup.log.*"
decoderStatusLog="procStatus.log"
decoderStatusLogsBackup="procStatus.log.*"
recorderLog="/opt/rec_debug.log"
psLogsBackup=ps_out.txt* 
netsrvLog="netsrvmgr.log"
netsrvLogsBackup="netsrvmgr.log.*"
samhainLog="samhain.log"
samhainLogsBackup="samhain.log.*"
fogLog="fog.log"
fogLogsBackup="fog.log.*"
hddStatusLog="diskinfo.log"
hddStatusLogsBackup="diskinfo.log.*"
xiRecoveryLog="discoverV4Client.log"
xiRecoveryLogsBackup="discoverV4Client.log.*"
dropbearLog="dropbear.log"
dropbearLogsBackup="dropbear.log.*"
bluetoothLog="btmgrlog.txt"
bluetoothLogBackup="btmgrlog.txt.*"
mountLog="mount_log.txt"
mountLogBackup="mount_log.txt.*"
rbiDaemonLog="rbiDaemon.log"
rbiDaemonLogsBackup="rbiDaemon.log.*"
rfcLog="rfcscript.log"
rfcLogsBackup="rfcscript.log.*"
tlsLog="tlsError.log"
tlsLogsBackup="tlsError.log.*"
playreadycdmiLog="playreadycdmi.log"
playreadycdmiLogsBackup="playreadycdmi.log.*"
wpecdmiLog="wpecdmi.log"
wpecdmiLogsBackup="wpecdmi.log.*"
pingTelemetryLog="ping_telemetry.log"
pingTelemetryLogsBackup="ping_telemetry.log.*"
deviceDetailsLog="device_details.log"
zramLog="zram.log"
zramLogsBackup="zram.log.*"
appmanagerLog="appmanager.log"
appmanagerLogsBackup="appmanager.log.*"
hwselfLog="hwselftest.log"
hwselfLogsBackup="hwselftest.log.*"
easPcapFile="eas.pcap"
mocaPcapFile="moca.pcap"
nlmonLog="nlmon.log"
nlmonLogsBackup="nlmon.log.*"
audiocapturemgrLogs="audiocapturemgr.log"

if [ "$CONTAINER_SUPPORT" == "true" ];then
    xreLxcLog="xre.log"
    xreLxcLogsBackup="xre.log.*"
    xreLxcApplicationsLog="xre-applications.log"
    xreLxcApplicationsLogsBackup="xre-applications.log.*"
fi

if [ "$SOC" = "BRCM" ];then
      nxSvrLog="nxserver.log"
      nxSvrLogsBackup="nxserver.log.*"
      procStatusLog="proc-status-logger.log"
      procStatusLogsBackup="proc-status-logger.log.*"
fi


if [ "$DEVICE_TYPE" != "mediaclient" ]; then
     riLog="ocapri_log.txt"
     riLogsBackup="ocapri_log.txt.*"
     riLogsBackup1="ocapri_log.txt_1"
     mpeosmainMON="mpeos-mainMON.txt"
     mpeosRebootLog="/opt/mpeos_reboot_log.txt"
     cardStatusLog="card_status.log"
     heapDmpLog="jvmheapdump.txt"
     rfStatisticsLog="rf_statistics_log.txt"
     ablReasonLog="ABLReason.txt"
     ecmLog="messages-ecm.txt"
     ecmLogsBackup="messages-ecm.txt.*"
     pumaLog="messages-puma.txt"
     pumaLogsBackup="messages-puma.txt.*"
     pumaLog1="messages-ecm.txt"
     pumaLogsBackup1="messages-ecm.txt.*"
     xfsdmesgLog="xfs_mount_dmesg.txt"
     snmpdLog="snmpd.log"
     snmpdLogsBackup="snmpd.log.*"
     upstreamStatsLog="upstream_stats.log"
     upstreamStatsLogsBackup="upstream_stats.log.*"
     dibblerLog="dibbler.log"
     dibblerLogsBackup="dibbler.log.*"
     dnsmasqLog="dnsmasq.log"
     dnsmasqLogsBackup="dnsmasq.log.*"
else
     ablReasonLog="ABLReason.txt"
     wifiTelemetryLog="wifi_telemetry.log"
     wifiTelemetryLogBackup="wifi_telemetry.log.*"
     tr69Log="tr69Client.log"
     tr69AgentLog="tr69agent.log"
     tr69HostIfLog="tr69hostif.log"
     gatewayLog="gwSetupLogs.txt"
     ipSetupLog="ipSetupLogs.txt"
     tr69DownloadLog="tr69FWDnld.log"
     tr69AgentHttpLog="tr69agent_HTTP.log"
     tr69AgentHttpLogsBackup="tr69agent_HTTP.log.*"
     tr69AgentSoapLog="tr69agent_SoapDebug.log"
     tr69AgentSoapLogsBackup="tr69agent_SoapDebug.log.*"
     webpavideoLog="webpavideo.log"
     webpavideoLogsBackup="webpavideo.log.*"
     xiConnectionStatusLog="xiConnectionStats.txt"
     xiConnectionStatusLogsBackup="xiConnectionStats.txt.*"
fi
if [ "$WIFI_SUPPORT" == "true" ];then
    wpaSupplicantLog="wpa_supplicant.log"
    wpaSupplicantLogsBackup="wpa_supplicant.log.*"
    dhcpWifiLog="dhcp-wifi.log"
    dhcpWifiLogsBackup="dhcp-wifi.log.*"
fi
if [ "$DEVICE_TYPE" ==  "XHC1" ];then

        streamsrvLog="stream_server_log.txt"
        streamsrvLogsBackup="stream_server_log.txt.*"

        stunnelHttpsLog="stunnel_https_log.txt"
        stunnelHttpsLogsBackup="stunnel_https_log.txt.*"

        upnpLog="upnp_log.txt"
        upnpLogsBackup="upnp_log.txt.*"

        upnpigdLog="upnpigd_log.txt"
        upnpigdLogsBackup="upnpigd_log.txt.*"

        cgiLog="cgi_log.txt"
        cgiLogsBackup="cgi_log.txt.*"

        systemLog="system_log.txt"
        systemLogsBackup="system_log.txt.*"

        eventLog="event_log.txt"
        eventLogsBackup="event_log.txt.*"

        xw3MonitorLog="oem_log.txt"
        xw3MonitorLogsBackup="oem_log.txt.*"

        sensorDLog="sensor_daemon_log.txt"
        sensorDLogsBackup="sensor_daemon_log.txt.*"

        webpaLog="webpa_log.txt"
        webpaLogsBackup="webpa_log.txt.*"
 
        xwclientLog="xwclient_log.txt"
        xwclientLogsBackup="xwclient_log.txt.*"

        xwswupdateLog="xwswupdate.log"
        xwswupdateLogsBackup="xwswupdate.log.*"
 
        userLog="user_log.txt"
        userLogsBackup="user_log.txt.*"
        
        webrtcStreamingLog="webrtc_streaming_log.txt"
        webrtcStreamingLogsBackup="webrtc_streaming_log.txt.*"
        
        cvrPollLog="cvrpoll_log.txt"
        cvrPollLogsBackup="cvrpoll_log.txt.*"
  
        thumbnailUploadLog="thumbnail_log.txt"
        thumbnailUploadBackupLog="thumbnail_log.txt.*"
	 
        metricsLog="dmesg_log.txt"
        metricsLogsBackup="dmesg_log.txt.*"

        wifiLog="wifi_log.txt"
        wifiLogsBackup="wifi_log.txt.*"

        rfcLog="rfcscript.log"
        rfcLogsBackup="rfcscript.log.*"

	overlayLog="overlay_log.txt"
	overlayLogsBackup="overlay_log.txt.*"

        xvisionLog="xvision_log.txt"
        xvisionLogsBackup="xvision_log.txt.*"

        ivaDaemonLog="iva_daemon_log.txt"
        ivaDaemonLogsBackup="iva_daemon_log.txt.*"

        evoLog="evo_log.txt"
        evoBackupLog="evo_log.txt.*"

	camstreamsrvLog="camstreamserver.log"
        camstreamsrvLogsBackup="camstreamserver.log.*"

        mongsLog="mongoose-cam-stream-server.txt"
        mongsLogsBackup="mongoose-cam-stream-server.txt.*"
fi

if [ "$HDD_ENABLED" = "false" ]; then
    sysLogBAK1="bak1_messages.txt"
    sysLogBAK2="bak2_messages.txt"
    sysLogBAK3="bak3_messages.txt"
    logBAK1="bak1_*"
    logBAK2="bak2_*"
    logBAK3="bak3_*"
fi

moveFile()
{        
     if [[ -f $1 ]]; then mv $1 $2; fi
}
 
moveFiles()
{
     currentDir=`pwd`
     cd $2
     
     for f in `ls $3 2>/dev/null`
     do
       $1 $f $4
     done
     
     cd $currentDir
}

backup()
{
    source=$1
    destn=$2
    operation=$3
    if [ "$DEVICE_TYPE" != "mediaclient" ]; then
          if [ -f $source$riLog ] ; then $operation $source$riLog $destn; fi
          if [ -f $mpeosRebootLog ] ; then
               if [ "$BUILD_TYPE" = "dev" ]; then
                    cp $mpeosRebootLog $destn
                    mv $recorderLog $destn
               else
                    mv $recorderLog $destn
                    $operation $mpeosRebootLog $destn
               fi
          fi
    fi
    if [ -f $source$xreLog ] ; then $operation $source$xreLog $destn; fi
    if [ -f $source$cecLog ] ; then $operation $source$cecLog $destn; fi
    if [ -f $source$wbLog ] ; then $operation $source$wbLog $destn; fi
    if [ -f $source$sysLog ] ; then $operation $source$sysLog $destn; fi
    if [ -f $source$ntpLog ] ; then $operation $source$ntpLog $destn; fi
    if [ -f $source/$uiLog ] ; then $operation $source/$uiLog $destn; fi
    if [ -f $source/$storagemgrLog ] ; then $operation $source/$storagemgrLog $destn; fi
    if [ -f $source/$rf4ceLog ] ; then $operation $source/$rf4ceLog $destn; fi
    if [ -f $source/$ctrlmLog ] ; then $operation $source/$ctrlmLog $destn; fi
    if [ -f $source/$applicationsLog ] ; then $operation $source/$applicationsLog $destn; fi
    if [ -f $source/$systemLog ] ; then $operation $source/$systemLog $destn; fi
    if [ -f $source/$bootUpLog ] ; then $operation $source/$bootUpLog $destn; fi
    if [ -f $source/$startupDmesgLog ] ; then $operation $source/$startupDmesgLog $destn; fi
    if [ -f $source/$diskCleanupLog ] ; then $operation $source/$diskCleanupLog $destn; fi
    if [ -f $source/$diskCleanupInfoLog ] ; then $operation $source/$diskCleanupInfoLog $destn; fi
    if [ -f $source/$diskCleanupLog1 ] ; then $operation $source/$diskCleanupLog1 $destn; fi
    if [ -f $source$sysDmesgLog ] ; then $operation $source$sysDmesgLog $destn; fi
    if [ -f $source$coreDumpLog ] ; then $operation $source$coreDumpLog $destn; fi
    if [ -f $source$adobeCleanupLog ] ; then $operation $source$adobeCleanupLog $destn; fi
    if [ -f $source$bluetoothLog ] ; then $operation $source$bluetoothLog $destn; fi
    if [ -f $source$easPcapFile ] ; then $operation $source$easPcapFile $destn; fi
    if [ -f $source$mocaPcapFile ] ; then $operation $source$mocaPcapFile $destn; fi
    if [ -f $source$mountLog ] ; then $operation $source$mountLog $destn; fi
    if [ "$CONTAINER_SUPPORT" == "true" ];then
        if [ -f $source$xreLxcLog ] ; then $operation $source$xreLxcLog $destn; fi
        if [ -f $source/$xreLxcApplicationsLog ] ; then $operation $source/$xreLxcApplicationsLog $destn; fi
    fi

    if [ "$SOC" = "BRCM" ];then
         if [ -f $source$nxSvrLog ] ; then $operation $source$nxSvrLog $destn; fi
         if [ -f $source$procStatusLog ] ; then $operation $source$procStatusLog $destn; fi
    fi
}

crashLogsBackup()
{
    opern=$1
    src=$2
    destn=$3

    moveFiles $opern $src receiver.log_* $destn
    moveFiles $opern $src ocapri_log.txt_* $destn
    moveFiles $opern $src messages.txt_* $destn
    moveFiles $opern $src app_status_backup.log_* $destn
}

backupAppBackupLogFiles()
{
     opern=$1
     source=$2
     destn=$3
    
     if [ "$DEVICE_TYPE" != "mediaclient" ]; then
	 moveFiles $opern $source $BootTimeLogBackup $destn
 	 moveFiles $opern $source $speedtestLogBackup $destn
	 moveFiles $opern $source $ArmConsolelogBackup $destn
	 moveFiles $opern $source $ConsolelogBackup $destn
	 moveFiles $opern $source $PAMlogBackup $destn
	 moveFiles $opern $source $PARODUSlogBackup $destn
	 moveFiles $opern $source $PSMlogBackup $destn
	 moveFiles $opern $source $TDMlogBackup $destn
	 moveFiles $opern $source $TR69logBackup $destn
	 moveFiles $opern $source $WEBPAlogBackup $destn
	 moveFiles $opern $source $WiFilogBackup $destn
	 moveFiles $opern $source $FirewallDebugBackup $destn
	 moveFiles $opern $source $MnetDebugBackup $destn
         moveFiles $opern $source $wifihealthBackup $destn
	 moveFiles $opern $source $CRLogBackup $destn
	 moveFiles $opern $source $LMlogBackup $destn

         moveFiles $opern $source $riLogsBackup $destn
         moveFiles $opern $source $riLogsBackup1 $destn
	 moveFiles $opern $source $ecmLogsBackup $destn
         moveFiles $opern $source $pumaLogsBackup $destn
         moveFiles $opern $source $pumaLogsBackup1 $destn
         moveFiles $opern $source $snmpdLogsBackup $destn
         moveFiles $opern $source $upstreamStatsLogsBackup $destn
         moveFiles $opern $source $dibblerLogsBackup $destn
         moveFiles $opern $source $dnsmasqLogsBackup $destn
     else
         moveFiles $opern $source $wifiTelemetryLogBackup $destn
         moveFiles $opern $source $tr69AgentHttpLogsBackup $destn
         moveFiles $opern $source $tr69AgentSoapLogsBackup $destn
         moveFiles $opern $source $webpavideoLogsBackup $destn
         moveFiles $opern $source $xiConnectionStatusLogsBackup $destn
     fi
     if [ "$WIFI_SUPPORT" == "true" ];then
         moveFiles $opern $source $wpaSupplicantLogsBackup $destn
         moveFiles $opern $source $dhcpWifiLogsBackup $destn
     fi
     if [ "$DEVICE_TYPE" ==  "XHC1" ];then
        moveFiles $opern $source $streamsrvLogsBackup $destn
        moveFiles $opern $source $stunnelHttpsLogsBackup $destn
        moveFiles $opern $source $upnpLogsBackup $destn
        moveFiles $opern $source $upnpigdLogsBackup $destn
        moveFiles $opern $source $cgiLogsBackup $destn
        moveFiles $opern $source $systemLogsBackup $destn
        moveFiles $opern $source $eventLogsBackup $destn
        moveFiles $opern $source $xw3MonitorLogsBackup $destn
        moveFiles $opern $source $sensorDLogsBackup $destn
        moveFiles $opern $source $webpaLogsBackup $destn
        moveFiles $opern $source $xwclientLogsBackup $destn
        moveFiles $opern $source $xwswupdateLogsBackup $destn
        moveFiles $opern $source $userLogsBackup $destn
        moveFiles $opern $source $webrtcStreamingLogsBackup $destn
        moveFiles $opern $source $cvrPollLogsBackup $destn
        moveFiles $opern $source $ivaDaemonLogsBackup $destn
        moveFiles $opern $source $thumbnailUploadBackupLog $destn
        moveFiles $opern $source $metricsLogsBackup $destn
        moveFiles $opern $source $wifiLogsBackup $destn
        moveFiles $opern $source $dcmLogsBackup $destn
        moveFiles $opern $source $netsrvLogsBackup $destn
        moveFiles $opern $source $diskCleanupLogsBackup $destn
        moveFiles $opern $source $applicationsLogsBackup $destn
        moveFiles $opern $source $rfcLogsBackup $destn
        moveFiles $opern $source $overlayLogsBackup $destn
        moveFiles $opern $source $sysLogsBackup $destn
        moveFiles $opern $source $startupDmesgLogsBackup $destn
        moveFiles $opern $source $sysDmesgLogsBackup $destn
        moveFiles $opern $source $xvisionLogsBackup $destn
        moveFiles $opern $source $evoBackupLog $destn
	moveFiles $opern $source $camstreamsrvLogsBackup $destn
	moveFiles $opern $source $mongsLogsBackup $destn
     else
     	moveFiles $opern $source $mocaStatusLogsBackup $destn
     	moveFiles $opern $source $runXreLogsBackup $destn
     	moveFiles $opern $source $xreLogsBackup $destn
     	moveFiles $opern $source $cecLogsBackup $destn
     	moveFiles $opern $source $sysLogsBackup $destn
     	moveFiles $opern $source $ntpLogsBackup $destn
     	moveFiles $opern $source $startupDmesgLogsBackup $destn
     	moveFiles $opern $source $gpInitLogsBackup $destn
     	moveFiles $opern $source $appStatusLogsBackup $destn
     	moveFiles $opern $source $dmesgLogsBackup $destn
     	moveFiles $opern $source $xDiscoveryLogsBackup $destn
     	moveFiles $opern $source $xDiscoveryListLogsBackup $destn
     	moveFiles $opern $source $uiLogsBackup $destn
     	moveFiles $opern $source $storagemgrLogsBackup $destn
     	moveFiles $opern $source $rf4ceLogsBackup $destn
     	moveFiles $opern $source $ctrlmLogsBackup $destn
     	moveFiles $opern $source $lighttpdErrorLogsBackup $destn
     	moveFiles $opern $source $lighttpdAccessLogsBackup $destn
     	moveFiles $opern $source $dcmLogsBackup $destn
     	moveFiles $opern $source $greenpeakLogsBackup $destn
     	moveFiles $opern $source $trmLogsBackup $destn
     	moveFiles $opern $source $trmMgrLogsBackup $destn
     	moveFiles $opern $source $rmfLogsBackup $destn
     	moveFiles $opern $source $podLogsBackup $destn
     	moveFiles $opern $source $vodLogsBackup $destn
     	moveFiles $opern $source $fdsLogsBackup $destn
     	moveFiles $opern $source $threadLogsBackup $destn
     	moveFiles $opern $source $xDeviceLogsBackup $destn
     	moveFiles $opern $source $coreDumpLogsBackup $destn
     	moveFiles $opern $source $applicationsLogsBackup $destn
     	moveFiles $opern $source $socProvisionLogsBackup $destn
        moveFiles $opern $source $socProvisionCryptoLogsBackup $destn
     	moveFiles $opern $source $topOsalLogsBackup $destn
     	moveFiles $opern $source $decoderStatusLogsBackup $destn
     	moveFiles $opern $source $mfrLogsBackup $destn
     	moveFiles $opern $source $mfrLogsRdkBackup $destn
     	moveFiles $opern $source $sysDmesgLogsBackup $destn
     	moveFiles $opern $source $resetLogsBackup $destn
     	moveFiles $opern $source $gpLogsBackup $destn
     	moveFiles $opern $source $psLogsBackup $destn
     	moveFiles $opern $source $cefLogsBackup $destn
     	moveFiles $opern $source $topLogsBackup $destn
     	moveFiles $opern $source $netsrvLogsBackup $destn
     	moveFiles $opern $source $diskCleanupLogsBackup $destn
     	moveFiles $opern $source $samhainLogsBackup $destn
        moveFiles $opern $source $fogLogsBackup $destn
     	moveFiles $opern $source $hddStatusLogsBackup $destn
     	moveFiles $opern $source $xiRecoveryLogsBackup $destn
     	moveFiles $opern $source $dropbearLogsBackup $destn
     	moveFiles $opern $source $bluetoothLogBackup $destn
     	moveFiles $opern $source $easPcapFile $destn
     	moveFiles $opern $source $mocaPcapFile $destn
        moveFiles $opern $source $mountLogBackup $destn
        moveFiles $opern $source $rbiDaemonLogsBackup $destn
        moveFiles $opern $source $rfcLogsBackup $destn
        moveFiles $opern $source $tlsLogsBackup $destn
        moveFiles $opern $source $playreadycdmiLogsBackup $destn
        moveFiles $opern $source $wpecdmiLogsBackup $destn
        moveFiles $opern $source $pingTelemetryLogsBackup $destn
        moveFiles $opern $source $zramLogsBackup $destn
        moveFiles $opern $source $appmanagerLogsBackup $destn
        moveFiles $opern $source $nlmonLogsBackup $destn
        moveFiles $opern $source $hwselfLogsBackup $destn
     fi

     if [ "$CONTAINER_SUPPORT" == "true" ];then
         moveFiles $opern $source $xreLxcLogsBackup $destn
         moveFiles $opern $source $xreLxcApplicationsLogsBackup $destn
     fi

     moveFiles $opern $source $systemLogsBackup $destn
     if [ "$SOC" = "BRCM" ];then
          moveFiles $opern $source $nxSvrLogsBackup $destn
          moveFiles $opern $source $procStatusLogsBackup $destn
     fi
     # backup older cycle logs
     if [ "$MEMORY_LIMITATION_FLAG" = "true" ]; then
          moveFiles $opern $source $logBAK1 $destn
          moveFiles $opern $source $logBAK2 $destn
          moveFiles $opern $source $logBAK3 $destn
     fi

}

backupSystemLogFiles()
{
     operation=$1
     source=$2
     destn=$3

     if [ -f $source/$BootTimeLog ] ; then $operation $source/$BootTimeLog $destn; fi
     if [ -f $source/$speedtestLog ] ; then $operation $source/$speedtestLog $destn; fi
     if [ -f $source/$ArmConsolelog ] ; then $operation $source/$ArmConsolelog $destn; fi
     if [ -f $source/$Consolelog ] ; then $operation $source/$Consolelog $destn; fi
     if [ -f $source/$LMlog ] ; then $operation $source/$LMlog $destn; fi
     if [ -f $source/$PAMlog ] ; then $operation $source/$PAMlog $destn; fi
     if [ -f $source/$PARODUSlog ] ; then $operation $source/$PARODUSlog $destn; fi
     if [ -f $source/$PSMlog ] ; then $operation $source/$PSMlog $destn; fi
     if [ -f $source/$TDMlog ] ; then $operation $source/$TDMlog $destn; fi
     if [ -f $source/$TR69log ] ; then $operation $source/$TR69log $destn; fi
     if [ -f $source/$WEBPAlog ] ; then $operation $source/$WEBPAlog $destn; fi
     if [ -f $source/$WiFilog ] ; then $operation $source/$WiFilog $destn; fi
     if [ -f $source/$FirewallDebug ] ; then $operation $source/$FirewallDebug $destn; fi
     if [ -f $source/$MnetDebug ] ; then $operation $source/$MnetDebug $destn; fi 
     if [ -f $source/$wifihealthlog ] ; then $operation $source/$wifihealthlog $destn; fi
     if [ -f $source/$CRLog ] ; then $operation $source/$CRLog $destn; fi


     # generic Logs
     if [ -f $source/$systemLog ] ; then $operation $source/$systemLog $destn; fi
     if [ -f $source/$resetLog ] ; then $operation $source/$resetLog $destn; fi
     if [ -f $source/$backUpDumpLog ] ; then $operation $source/$backUpDumpLog $destn; fi
     if [ -f $source/$bootUpLog ] ; then $operation $source/$bootUpLog $destn; fi
     if [ -f $source/$applicationsLog ] ; then $operation $source/$applicationsLog $destn; fi
     if [ -f $source/$runXreLog ] ; then $operation $source/$runXreLog $destn; fi
     if [ -f $source/$xreLog ] ; then $operation $source/$xreLog $destn; fi
     if [ -f $source/$cecLog ] ; then $operation $source/$cecLog $destn; fi
     if [ -f $source/$gpInitLog ] ; then $operation $source/$gpInitLog $destn; fi
     if [ -f $source/$hdmiLog ] ; then $operation $source/$hdmiLog $destn; fi
     if [ -f $source/$uiLog ] ; then $operation $source/$uiLog $destn; fi
     if [ -f $source/$storagemgrLog ] ; then $operation $source/$storagemgrLog $destn; fi
     if [ -f $source/$rf4ceLog ] ; then $operation $source/$rf4ceLog $destn; fi
     if [ -f $source/$ctrlmLog ] ; then $operation $source/$ctrlmLog $destn; fi
     if [ -f $source/$ipdnlLog ] ; then $operation $source/$ipdnlLog $destn; fi

     if [ -f $source/$fdsLog ] ; then $operation $source/$fdsLog $destn; fi
     if [ -f $source/$dmesgLog ] ; then $operation $source/$dmesgLog $destn; fi
     if [ -f $source/$appStatusLog ] ; then $operation $source/$appStatusLog $destn; fi
     if [ -f $source/$gpLog ]; then $operation $source/$gpLog $destn; fi
     if [ -f $source/$sysLog ] ; then $operation $source/$sysLog $destn; fi
     if [ -f $source/$ntpLog ] ; then $operation $source/$ntpLog $destn; fi
     if [ -f $source/$wbLog ] ; then $operation $source/$wbLog $destn; fi
     if [ -f $source/$ueiLog ] ; then $operation $source/$ueiLog $destn; fi
     if [ -f $source/$receiverMON ] ; then $operation $source/$receiverMON $destn; fi
     if [ -f $source/$swUpdateLog ] ; then $operation $source/$swUpdateLog $destn; fi
     if [ -f $source/$topLog ] ; then $operation $source/$topLog $destn; fi
     if [ -f $source/$fusionDaleLog ] ; then $operation $source/$fusionDaleLog $destn; fi

     if [ -f $source/$mfrLog ] ; then $operation $source/$mfrLog $destn; fi
     if [ -f $source/$mocaLog ] ; then $operation $source/$mocaLog $destn; fi
     if [ -f $source/$rebootLog ] ; then $operation $source/$rebootLog $destn; fi
     if [ -f $source/$rebootInfoLog ] ; then $operation $source/$rebootInfoLog $destn; fi
     if [ -f $source/$xDiscoveryLog ] ; then $operation $source/$xDiscoveryLog $destn; fi
     if [ -f $source/$xDiscoveryListLog ] ; then $operation $source/$xDiscoveryListLog $destn; fi

     if [ -f $source/$socProvisionLog ] ; then $operation $source/$socProvisionLog $destn; fi
     if [ -f $source/$socProvisionCryptoLog ] ; then $operation $source/$socProvisionCryptoLog $destn; fi
     if [ -f $source/$lighttpdErrorLog ] ; then $operation $source/$lighttpdErrorLog $destn; fi
     if [ -f $source/$lighttpdAccessLog ] ; then $operation $source/$lighttpdAccessLog $destn; fi
     if [ -f $source/$dcmLog ] ; then $operation $source/$dcmLog $destn; fi
     if [ -f $source/$coreDumpLog ] ; then $operation $source/$coreDumpLog $destn; fi
     if [ -f $source/$mountLog ] ; then $operation $source/$mountLog $destn; fi
     if [ -f $source/$rbiDaemonLog ] ; then $operation $source/$rbiDaemonLog $destn; fi
     if [ -f $source/$rfcLog ] ; then $operation $source/$rfcLog $destn; fi
     if [ -f $source/$tlsLog ] ; then $operation $source/$tlsLog $destn; fi
     if [ -f $source/$playreadycdmiLog ] ; then $operation $source/$playreadycdmiLog $destn; fi
     if [ -f $source/$wpecdmiLog ] ; then $operation $source/$wpecdmiLog $destn; fi
     if [ -f $source/$pingTelemetryLog ] ; then $operation $source/$pingTelemetryLog $destn; fi
     if [ -f $source/$deviceDetailsLog ] ; then $operation $source/$deviceDetailsLog $destn; fi
     if [ -f $source/$zramLog ] ; then $operation $source/$zramLog $destn; fi
     if [ -f $source/$appmanagerLog ] ; then $operation $source/$appmanagerLog $destn; fi
     if [ -f $source/$nlmonLog ] ; then $operation $source/$nlmonLog $destn; fi
     if [ -f $source/$hwselfLog ] ; then $operation $source/$hwselfLog $destn; fi
     if [ "$CONTAINER_SUPPORT" == "true" ];then
         if [ -f $source/$xreLxcApplicationsLog ] ; then $operation $source/$xreLxcApplicationsLog $destn; fi
         if [ -f $source/$xreLxcLog ] ; then $operation $source/$xreLxcLog $destn; fi
     fi

     #Adding a work around to create core_log.txt whith restricted user privilege
     #if linux multi user is enabled
     if [ "$ENABLE_MULTI_USER" == "true" ] && [ ! -f /etc/os-release ] ; then
        if [ "$BUILD_TYPE" == "prod" ] ; then
            touch $source/$coreDumpLog
            chown restricteduser:restrictedgroup $source/$coreDumpLog
        else
            if [ ! -f /opt/disable_chrootXREJail ]; then
                touch $source/$coreDumpLog
                chown restricteduser:restrictedgroup $source/$coreDumpLog
            fi
        fi
     fi
     #End of work around related to core_log.txt for Linux multi user support
     if [ -f $source/$trmLog ] ; then $operation $source/$trmLog $destn; fi
     if [ -f $source/$trmMgrLog ] ; then $operation $source/$trmMgrLog $destn; fi
     if [ -f $source/$threadLog ] ; then $operation $source/$threadLog $destn; fi
     if [ -f $source/$greenpeakLog ]; then $operation $source/$greenpeakLog $destn; fi
     if [ -f $source/$startupDmesgLog ] ; then $operation $source/$startupDmesgLog $destn; fi
     if [ -f $source/$coreLog ] ; then $operation $source/$coreLog $destn; fi
     if [ -f $source/$xDeviceLog ] ; then $operation $source/$xDeviceLog $destn; fi
     if [ -f $source/$rmfLog ] ; then $operation $source/$rmfLog $destn; fi
     if [ "$DEVICE_TYPE" != "mediaclient" ]; then
          if [ -f $source/$podLog ] ; then $operation $source/$podLog $destn; fi
          if [ -f $source/$vodLog ] ; then $operation $source/$vodLog $destn; fi
          if [ -f $source/$diskEventsLog ] ; then $operation $source/$diskEventsLog $destn; fi
          if [ -f $source/$diskInfoLog ] ; then $operation $source/$diskInfoLog $destn; fi
          if [ -f $source/$ablReasonLog ] ; then $operation $source/$ablReasonLog $destn; fi
          if [ -f $source/$mpeosmainMON ] ; then $operation $source/$mpeosmainMON $destn; fi
          if [ -f $source/$ecmLog ] ; then $operation $source/$ecmLog $destn; fi
          if [ -f $source/$pumaLog ] ; then $operation $source/$pumaLog $destn; fi
          if [ -f $source/$pumaLog1 ] ; then $operation $source/$pumaLog1 $destn; fi
          if [ -f $source/$heapDmpLog ] ; then $operation $source/$heapDmpLog $destn; fi
          if [ -f $source/$cardStatusLog ] ; then $operation $source/$cardStatusLog $destn; fi
          if [ -f $source/$rfStatisticsLog ] ; then $operation $source/$rfStatisticsLog $destn; fi
	  if [ -f $source/$riLog ] ; then $operation $source/$riLog $destn; fi
	  if [ -f $source/$xfsdmesgLog ] ; then $operation $source/$xfsdmesgLog $destn; fi
          if [ -f $mpeosRebootLog ] ; then 
               if [ "$BUILD_TYPE" = "dev" ]; then
                    cp $mpeosRebootLog $destn
               else
                    $operation $mpeosRebootLog $destn
               fi
          fi
          if [ "$LIGHTSLEEP_ENABLE" = "true" ]; then
               if [ -f $source/lightsleep.log ] ; then $operation $source/lightsleep.log $destn; fi
          fi
          if [ -f $source/$snmpdLog ] ; then $operation $source/$snmpdLog $destn; fi
          if [ -f $source/$upstreamStatsLog ] ; then $operation $source/$upstreamStatsLog $destn; fi
          if [ -f $source/$dibblerLog ] ; then $operation $source/$dibblerLog $destn; fi
          if [ -f $source/$dnsmasqLog ] ; then $operation $source/$dnsmasqLog $destn; fi
     else
	  if [ -f $source/$wifiTelemetryLog ] ; then $operation $source/$wifiTelemetryLog $destn; fi
	  if [ -f $source/$tr69Log ] ; then $operation $source/$tr69Log $destn; fi
	  if [ -f $source/$tr69AgentLog ] ; then $operation $source/$tr69AgentLog $destn; fi
	  if [ -f $source/$tr69HostIfLog ] ; then $operation $source/$tr69HostIfLog $destn; fi
	  if [ -f $source/$tr69DownloadLog ] ; then $operation $source/$tr69DownloadLog $destn; fi
	  if [ -f $source/$gatewayLog ] ; then $operation $source/$gatewayLog $destn; fi
	  if [ -f $source/$ipSetupLog ] ; then $operation $source/$ipSetupLog $destn; fi
	  if [ -f $source/$tr69AgentHttpLog ] ; then $operation $source/$tr69AgentHttpLog $destn; fi
	  if [ -f $source/$tr69AgentSoapLog ] ; then $operation $source/$tr69AgentSoapLog $destn; fi
          if [ -f $source/$webpavideoLog ] ; then $operation $source/$webpavideoLog $destn; fi
          if [ -f $source/$xiConnectionStatusLog ] ; then $operation $source/$xiConnectionStatusLog $destn; fi
     fi
     # backup version.txt
     if [ -f $source/$version ] ; then 
	     $operation $source/$version $destn
     else
	     cp /$version $destn
     fi
     # backup older cycle logs
     if [ -f $source/$rstreamFdLog ] ; then $operation $source/$rstreamFdLog $destn; fi
     if [ -f $source/$authServiceLog ] ; then $operation $source/$authServiceLog $destn; fi
     if [ -f $source/$cardProvisionCheckLog ] ; then $operation $source/$cardProvisionCheckLog $destn; fi
     if [ -f $source/$diskCleanupLog ] ; then $operation $source/$diskCleanupLog $destn; fi
     if [ -f $source/$diskCleanupInfoLog ] ; then $operation $source/$diskCleanupInfoLog $destn; fi
     if [ -f $recorderLog ]; then mv $recorderLog $destn; fi
     if [ -f $source/$topOsalLog ] ; then $operation $source/$topOsalLog $destn; fi
     if [ -f $source/$mocaStatusLog ] ; then $operation $source/$mocaStatusLog $destn; fi
     if [ -f $source/$decoderStatusLog ] ; then $operation $source/$decoderStatusLog $destn; fi
     if [ -f $source/$mfrLogRdk ] ; then $operation $source/$mfrLogRdk $destn; fi
     if [ -f $source/$cefLog ] ; then $operation $source/$cefLog $destn; fi
     if [ -f $source/$diskCleanupLog1 ] ; then $operation $source/$diskCleanupLog1 $destn; fi
     if [ -f $source/$sysDmesgLog ] ; then $operation $source/$sysDmesgLog $destn; fi
     if [ -f $source/$samhainLog ] ; then $operation $source/$samhainLog $destn; fi
     if [ -f $source/$fogLog ] ; then $operation $source/$fogLog $destn; fi
     if [ -f $source/$hddStatusLog ] ; then $operation $source/$hddStatusLog $destn; fi
     if [ -f $source/$xiRecoveryLog ] ; then $operation $source/$xiRecoveryLog $destn; fi
     if [ -f $source/$dropbearLog ] ; then $operation $source/$dropbearLog $destn; fi

     if [ "$SOC" = "BRCM" ];then
         if [ -f $source/$nxSvrLog ] ; then $operation $source/$nxSvrLog $destn; fi
         if [ -f $source/$procStatusLog ] ; then $operation $source/$procStatusLog $destn; fi
     fi
     if [ -f $source/$netsrvLog ] ; then $operation $source/$netsrvLog $destn; fi
     if [ -f $source/$adobeCleanupLog ] ; then $operation $source/$adobeCleanupLog $destn; fi
	  
    if [ "$DEVICE_TYPE" ==  "XHC1" ];then
        if [ -f $source/$streamsrvLog ] ; then $operation $source/$streamsrvLog $destn; fi
	if [ -f $source/$stunnelHttpsLog ] ; then $operation $source/$stunnelHttpsLog $destn; fi
	if [ -f $source/$upnpLog ] ; then $operation $source/$upnpLog $destn; fi
        if [ -f $source/$upnpigdLog ] ; then $operation $source/$upnpigdLog $destn; fi
	if [ -f $source/$cgiLog ] ; then $operation $source/$cgiLog $destn; fi
	if [ -f $source/$systemLog ] ; then $operation $source/$systemLog $destn; fi
	if [ -f $source/$eventLog ] ; then $operation $source/$eventLog $destn; fi
	if [ -f $source/$xw3MonitorLog ] ; then $operation $source/$xw3MonitorLog $destn; fi
        if [ -f $source/$sensorDLog ] ; then $operation $source/$sensorDLog $destn; fi
        if [ -f $source/$webpaLog ] ; then $operation $source/$webpaLog $destn; fi
        if [ -f $source/$xwclientLog ] ; then $operation $source/$xwclientLog $destn; fi
        if [ -f $source/$xwswupdateLog ] ; then $operation $source/$xwswupdateLog $destn; fi
        if [ -f $source/$userLog ] ; then $operation $source/$userLog $destn; fi
        if [ -f $source/$webrtcStreamingLog ] ; then $operation $source/$webrtcStreamingLog $destn; fi
	if [ -f $source/$cvrPollLog ] ; then $operation $source/$cvrPollLog $destn; fi
	if [ -f $source/$ivaDaemonLog ] ; then $operation $source/$ivaDaemonLog $destn; fi
	if [ -f $source/$thumbnailUploadLog ] ; then $operation $source/$thumbnailUploadLog $destn; fi
	if [ -f $source/$metricsLog ] ; then $operation $source/$metricsLog $destn; fi
	if [ -f $source/$wifiLog ] ; then $operation $source/$wifiLog $destn; fi
        if [ -f $source/$overlayLog ] ; then $operation $source/$overlayLog $destn; fi
        if [ -f $source/$xvisionLog ] ; then $operation $source/$xvisionLog $destn; fi
        if [ -f $source/$evoLog ] ; then $operation $source/$evoLog $destn; fi
	if [ -f $source/$camstreamsrvLog ] ; then $operation $source/$camstreamsrvLog $destn; fi
	if [ -f $source/$mongsLog ] ; then $operation $source/$mongsLog $destn; fi
     fi
     if [ "$WIFI_SUPPORT" == "true" ];then
        if [ -f $source/$wpaSupplicantLog ] ; then $operation $source/$wpaSupplicantLog $destn; fi
        if [ -f $source/$dhcpWifiLog ] ; then $operation $source/$dhcpWifiLog $destn; fi
     fi
     if [ -f $source/$audiocapturemgrLogs ] ; then $operation $source/$audiocapturemgrLogs $destn; fi

}

logCleanup()
{
  echo "Done Log Backup"
}

