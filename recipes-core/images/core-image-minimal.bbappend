SUMMARY = "Marvell RFS"

inherit rdk-image

#IMAGE_FEATURES += "broadband"
#IMAGE_ROOTFS_SIZE = "8192"

IMAGE_INSTALL_append = " \
    packagegroup-turris-core \
    "
IMAGE_INSTALL += " ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
		   ${CORE_IMAGE_EXTRA_INSTALL} \
		"
