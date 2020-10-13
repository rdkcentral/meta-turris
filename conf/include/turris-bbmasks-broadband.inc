BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-hotspot-kmod.bb"

BBMASK_dunfell .= "|meta-rdk/recipes-core/images/rdk-generic-mediaclient-nightly-image.bb"
BBMASK_dunfell .= "|meta-rdk.*/recipes-core/images/comcast/"
BBMASK_dunfell .= "|meta-rdk.*/recipes-extended/netzyn/"
BBMASK_dunfell .= "|meta-rdk/recipes-common/webpa/"
BBMASK_dunfell .= "|meta-rdk/recipes-common/rbus/rbus_git.bb"
BBMASK_dunfell .= "|meta-virtualization/recipes-devtools/python/python_2.7.9.bbappend"
BBMASK_dunfell .= "|meta-virtualization/recipes-kernel/linux/linux-yocto_3.19.bbappend"
