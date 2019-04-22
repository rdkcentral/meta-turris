inherit rdk-image
#inherit core-image

IMAGE_FEATURES_remove_rpi = "read-only-rootfs"

SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

#${ROOTFS_PKGMANAGE_BOOTSTRAP}
#${CORE_IMAGE_EXTRA_INSTALL}
IMAGE_INSTALL += " packagegroup-turris-core \
    ${SYSTEMD_TOOLS} \
    ccsp-webui \
    network-hotplug \
    php \
    libmcrypt \
    bzip2 \
    nmap \
    libpcap \
    bc \
    openvswitch \
    "
#removing openvswitch since it include net/if_packet.h which is not provided by musl(1.1.19)
IMAGE_INSTALL_remove = "openvswitch"
