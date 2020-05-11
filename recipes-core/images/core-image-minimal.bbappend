SUMMARY = "Marvell RFS"

inherit rdk-image

MACHINE_IMAGE_NAME = "core-image-minimal"

IMAGE_FEATURES_remove = "read-only-rootfs"

IMAGE_INSTALL_append = " \
    packagegroup-turris-core \
    "
IMAGE_INSTALL += " ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
		   ${CORE_IMAGE_EXTRA_INSTALL} \
		"
