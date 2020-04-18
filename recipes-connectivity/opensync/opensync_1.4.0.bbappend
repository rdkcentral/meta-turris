FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CMF_GIT_MASTER_BRANCH = "master"

CORE_URI = "git://git@github.com/plume-design/opensync.git;protocol=${CMF_GIT_PROTOCOL};branch=osync_1.4.0.1;name=core;destsuffix=git/core"
PLATFORM_URI = "git://git@github.com/plume-design/opensync-platform-rdk.git;protocol=${CMF_GIT_PROTOCOL};branch=osync_1.4.0;name=platform;destsuffix=git/platform/rdk"
PLATFORM_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://0001-add-mesh-header-file.patch;patchdir=${WORKDIR}/git/platform/rdk', '', d)}"
VENDOR_URI = "git://git@github.com/rdkcentral/opensync-vendor-rdk-turris.git;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};name=vendor;destsuffix=git/vendor/turris"

DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'mesh-agent', '', d)}"
