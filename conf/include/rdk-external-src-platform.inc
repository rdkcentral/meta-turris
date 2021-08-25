# Note: This feature is for developers ONLY.
# Please do not forget to set BB_ENV_EXTRAWHITE before
# launching the yocto build.
# `export BB_ENV_EXTRAWHITE="${BB_ENV_EXTRAWHITE} RDK_ROOT_PATH"`
#
INHERIT += "externalsrc"

EXTERNALSRC_pn-hal-dhcpv4c-generic = "${@'${RDK_ROOT_PATH}/rdkb/components/opensource/ccsp/hal/source/dhcpv4c' if (os.path.isdir('${RDK_ROOT_PATH}/rdkb/components/opensource/ccsp/hal/source/dhcpv4c/devices_turris')) else ''}"
EXTERNALSRC_pn-hal-ethsw-generic = "${@'${RDK_ROOT_PATH}/rdkb/components/opensource/ccsp/hal/source/ethsw' if (os.path.isdir('${RDK_ROOT_PATH}/rdkb/components/opensource/ccsp/hal/source/ethsw/devices_turris')) else ''}"
EXTERNALSRC_pn-hal-platform-generic = "${@'${RDK_ROOT_PATH}/rdkb/components/opensource/ccsp/hal/source/platform' if (os.path.isdir('${RDK_ROOT_PATH}/rdkb/components/opensource/ccsp/hal/source/platform/devices_turris')) else ''}"
EXTERNALSRC_pn-hal-wifi-turris = "${@'${RDK_ROOT_PATH}/rdkb/devices/turris/hal/source/wifi' if (os.path.isdir('${RDK_ROOT_PATH}/rdkb/devices/turris/hal')) else ''}"
