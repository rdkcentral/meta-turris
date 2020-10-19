FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CORE_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://0001-inet-start-dhcps-always.patch', '', d)}"
CORE_URI = "git://git@github.com/plume-design/opensync.git;protocol=${CMF_GIT_PROTOCOL};branch=osync_2.0.5;name=core;destsuffix=git/core"
CORE_URI += "file://0007-Fix-conflict-with-yocto-kernel-tools-kconfiglib.patch"
CORE_URI += "file://remove_target_managers.patch"
#CORE_URI += "file://remove_map.patch"
CORE_URI += "file://ping-fix.patch"
CORE_URI += "file://wm2-vif-sta-fix.patch"
CORE_URI += "file://lan-port-fix.patch"

PLATFORM_URI = "git://git@github.com/plume-design/opensync-platform-rdk.git;protocol=${CMF_GIT_PROTOCOL};branch=osync_2.0.5;name=platform;destsuffix=git/platform/rdk"
PLATFORM_URI += "file://use_stats2.patch;patchdir=${WORKDIR}/git/platform/rdk"
PLATFORM_URI += "file://rdk-vif-extender.patch;patchdir=${WORKDIR}/git/platform/rdk"

VENDOR_URI = "git://git@github.com/rdkcentral/opensync-vendor-rdk-turris.git;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};name=vendor;destsuffix=git/vendor/turris"
VENDOR_URI += "file://service.patch;patchdir=${WORKDIR}/git/"
VENDOR_URI += "file://opensync.service"

DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'mesh-agent', '', d)}"
DEPENDS_remove = "hal-wifi"
DEPENDS_append = " rdk-logger hal-wifi-turris"

RDK_CFLAGS += " -D_PLATFORM_TURRIS_"

inherit systemd

SYSTEMD_AUTO_ENABLE_${PN}_turris-extender = "enable"
SYSTEMD_SERVICE_${PN}_turris-extender = "opensync.service"

do_install_append_turris-extender() {
         install -d ${D}${systemd_unitdir}/system
         install -m 0644 ${WORKDIR}/opensync.service ${D}${systemd_unitdir}/system
}

