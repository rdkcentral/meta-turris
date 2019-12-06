CORE_URI = "git://git@github.com/plume-design/opensync.git;protocol=https;branch=osync_1.4.0;name=core;destsuffix=git/core"
PLATFORM_URI = "git://git@github.com/plume-design/opensync-platform-rdk.git;protocol=https;branch=osync_1.4.0;name=platform;destsuffix=git/platform/rdk"
VENDOR_URI = "git://git@github.com/rdkcentral/opensync-vendor-rdk-turris.git;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};name=vendor;destsuffix=git/vendor/turris"

DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'mesh-agent', '', d)}"
