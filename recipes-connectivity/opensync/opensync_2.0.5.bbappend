FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CORE_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://0002-Use-osync_hal-in-inet_gretap.patch', '', d)}"

CORE_URI_append_dunfell = " file://absolute-value-glibc-dunfell-fix.patch"
CORE_URI_append_dunfell = " file://dunfell-nm-crash-fix.patch"
CORE_URI_append_dunfell = " ${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://update-format-specifier-for-time_t.patch', '', d)}"

VENDOR_URI = "git://git@github.com/rdkcentral/opensync-vendor-rdk-turris.git;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MASTER_BRANCH};name=vendor;destsuffix=git/vendor/turris"
VENDOR_URI += "file://service.patch;patchdir=${WORKDIR}/git/"
VENDOR_URI += "file://opensync.service"

DEPENDS_append = " rdk-logger hal-wifi-cfg80211"

RDK_CFLAGS += " -D_PLATFORM_TURRIS_"
