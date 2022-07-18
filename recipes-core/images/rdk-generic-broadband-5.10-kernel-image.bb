inherit rdk-image

IMAGE_FEATURES_remove = "read-only-rootfs"

SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

IMAGE_INSTALL += " packagegroup-turris-core \
    ${SYSTEMD_TOOLS} \
    linux-firmware-ath10k \
    network-hotplug \
    libmcrypt \
    bzip2 \
    nmap \
    libpcap \
    tcpdump \
    ebtables \
    iw \
    ethtool \
    bc \
    mesh-agent \
    opensync \
    "

BB_HASH_IGNORE_MISMATCH = "1"
IMAGE_NAME[vardepsexclude] = "DATETIME"

require image-exclude-files.inc

remove_unused_file() {
   for i in ${REMOVED_FILE_LIST} ; do rm -rf ${IMAGE_ROOTFS}/$i ; done
}

ROOTFS_POSTPROCESS_COMMAND_append = "remove_unused_file; "

MACHINE_IMAGE_NAME = "rdk-generic-broadband-5.10-kernel-image"
