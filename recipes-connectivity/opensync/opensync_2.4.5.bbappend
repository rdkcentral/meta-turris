FILESEXTRAPATHS_prepend := "${THISDIR}/opensync_2.4.5:${THISDIR}/files:"
#FILESEXTRAPATHS_prepend := "${THISDIR}/opensync_2.4.5:${THISDIR}/files:"

CORE_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://0001-inet-start-dhcps-always.patch', '', d)}"
CORE_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://0002-Use-osync_hal-in-inet_gretap.patch', '', d)}"
CORE_URI_remove = "git://git@github.com/plume-design/opensync.git;protocol=ssh;branch=osync_2.0.5;name=core;destsuffix=git/core"
CORE_URI += "file://remove_target_managers.patch"
CORE_URI += "file://ping-fix.patch"
CORE_URI += "file://wm2-vif-sta-fix.patch"

CORE_URI_append_dunfell = " file://dunfell-nm-crash-fix.patch"
CORE_URI_append_dunfell = " ${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://update-format-specifier-for-time_t.patch', '', d)}"

PLATFORM_URI += "file://use_stats2.patch;patchdir=${WORKDIR}/git/platform/rdk"

VENDOR_URI = "git://github.com/rdkcentral/opensync-vendor-rdk-turris.git;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MASTER_BRANCH};name=vendor;destsuffix=git/vendor/turris"
VENDOR_URI += "file://service.patch;patchdir=${WORKDIR}/git/"
VENDOR_URI += "file://vendor.patch;patchdir=${WORKDIR}/git/vendor/turris"
VENDOR_URI += "file://opensync.service"

DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'mesh-agent', '', d)}"
DEPENDS_remove = "hal-wifi"
DEPENDS_append = " rdk-logger hal-wifi-cfg80211"

RDK_CFLAGS += " -D_PLATFORM_TURRIS_"

inherit systemd
FILES_${PN}_append = "${prefix}/sbin/*"

SYSTEMD_AUTO_ENABLE_${PN}_turris-extender = "enable"
SYSTEMD_SERVICE_${PN}_turris-extender = "opensync.service"

do_install_append_turris-extender() {
         install -d ${D}${systemd_unitdir}/system
         install -m 0644 ${WORKDIR}/opensync.service ${D}${systemd_unitdir}/system
}


CFLAGS_append = " \
    -I${STAGING_INCDIR}/dbus-1.0 \
    -I${STAGING_LIBDIR}/dbus-1.0/include \
    -I${STAGING_INCDIR}/ccsp \
"

