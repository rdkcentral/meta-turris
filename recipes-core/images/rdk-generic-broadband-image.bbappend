inherit rdk-image

IMAGE_FEATURES_remove = "read-only-rootfs"

SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

IMAGE_INSTALL += " packagegroup-turris-core \
    ${SYSTEMD_TOOLS} \
    linux-firmware-ath10k \
    ccsp-webui-csrf \
    network-hotplug \
    php \
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
    openvswitch \
    "
IMAGE_INSTALL_remove_dunfell += " ccsp-webui-php ccsp-webui-csrf ethtool"
BB_HASH_IGNORE_MISMATCH = "1"
IMAGE_NAME[vardepsexclude] = "DATETIME"
