SUMMARY = "Marvell RFS"

inherit rdk-image

MACHINE_IMAGE_NAME = "core-image-minimal"

IMAGE_FEATURES_remove = "read-only-rootfs"

IMAGE_INSTALL_append = " \
    packagegroup-turris-core \
    "
ROOTFS_PKGMANAGE_BOOTSTRAP  = "run-postinsts"

IMAGE_INSTALL += " ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
		   ${CORE_IMAGE_EXTRA_INSTALL} \
		"

BB_HASH_IGNORE_MISMATCH = "1"

IMAGE_NAME[vardepsexclude] = "DATETIME"
