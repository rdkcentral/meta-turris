SUMMARY = "A image for the RDK extender yocto build"

inherit rdk-image

IMAGE_FEATURES_remove = "read-only-rootfs"

IMAGE_ROOTFS_SIZE = "8192"

IMAGE_INSTALL += " packagegroup-turris-core \
    rdk-logger \
    ${SYSTEMD_TOOLS} \
    linux-firmware-ath10k \
    libmcrypt \
    bzip2 \
    libpcap \
    tcpdump \
    ebtables \
    dropbear \
    iw \
    opensync \
    openvswitch \
    libcap \
    bridge-utils \
    strace \
    wpa-supplicant \
    "
IMAGE_INSTALL_append_dunfell += " network-hotplug"

SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

do_rootfs[nostamp] = "1"

remove_unused_file() {
 rm -rf ${IMAGE_ROOTFS}/usr/lib/python* ;
}

ROOTFS_POSTPROCESS_COMMAND_append = "remove_unused_file; "
