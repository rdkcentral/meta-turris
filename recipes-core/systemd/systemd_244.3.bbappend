#set the watch dog timer
do_install_append () {
sed -i "/RuntimeWatchdogSec/c\RuntimeWatchdogSec=120"  ${D}/${sysconfdir}/systemd/system.conf
sed -i "/ShutdownWatchdogSec/c\ShutdownWatchdogSec=10min"   ${D}/${sysconfdir}/systemd/system.conf
}
