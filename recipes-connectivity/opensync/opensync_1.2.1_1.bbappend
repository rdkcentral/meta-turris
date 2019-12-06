CORE_URI = "git://git@github.com/plume-design/opensync.git;protocol=https;branch=osync_1.2.1;name=core;destsuffix=git/core"
PLATFORM_URI = "git://git@github.com/plume-design/opensync-platform-rdk.git;protocol=https;branch=osync_1.2.1_1;name=platform;destsuffix=git/platform/rdk"
VENDOR_URI = "git://git@github.com/plume-design/opensync-vendor-rdk-template.git;protocol=https;branch=osync_1.2.1_1;name=vendor;destsuffix=git/vendor/turris"
DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'mesh-agent', '', d)}"
