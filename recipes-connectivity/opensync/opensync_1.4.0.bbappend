VENDOR_URI = "git://git@github.com/rdkcentral/opensync-vendor-rdk-turris.git;protocol=https;branch=master;name=vendor;destsuffix=git/vendor/turris"

DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'mesh-agent', '', d)}"
