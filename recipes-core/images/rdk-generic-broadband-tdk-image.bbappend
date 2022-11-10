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
    libpcap \
    tcpdump \
    ebtables \
    iw \
    ethtool \
    bc \
    mesh-agent \
    opensync \
    openvswitch \
    mt79 \
    "

BB_HASH_IGNORE_MISMATCH = "1"
IMAGE_NAME[vardepsexclude] = "DATETIME"

#ESDK-CHANGES
do_populate_sdk_ext_prepend() {
    builddir = d.getVar('TOPDIR')
    if os.path.exists(builddir + '/conf/templateconf.cfg'):
        with open(builddir + '/conf/templateconf.cfg', 'w') as f:
            f.write('meta/conf\n')
}

sdk_ext_postinst_append() {
   echo "ln -s $target_sdk_dir/layers/openembedded-core/meta-rdk $target_sdk_dir/layers/openembedded-core/../meta-rdk \n" >> $env_setup_script
}

PRSERV_HOST = "localhost:0"
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"

require image-exclude-files.inc

remove_unused_file() {
    for i in ${REMOVED_FILE_LIST} ; do rm -rf ${IMAGE_ROOTFS}/$i ; done
}

ssh_workaround_opt_secure() {
    #Creating /opt/secure folder for ssh service
    install -d ${IMAGE_ROOTFS}/opt/secure
}

ROOTFS_POSTPROCESS_COMMAND_append = " remove_unused_file; ssh_workaround_opt_secure; "
