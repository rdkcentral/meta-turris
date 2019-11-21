SUMMARY = "A image for the RDK extender yocto build"

inherit rdk-image

IMAGE_FEATURES_remove = "read-only-rootfs"

IMAGE_ROOTFS_SIZE = "8192"

IMAGE_INSTALL += " packagegroup-turris-core \
    rdk-logger \
    ${SYSTEMD_TOOLS} \
    linux-firmware-ath10k \
    network-hotplug \
    php \
    libmcrypt \
    bzip2 \
    nmap \
    libpcap \
    tcpdump \
    ebtables \
    dropbear \
    iw \
    bc \
    opensync \
    openvswitch \
    libcap \
    bridge-utils \
    strace \
    "

SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

do_rootfs[nostamp] = "1"
