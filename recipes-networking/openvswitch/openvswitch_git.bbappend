DEPENDS_remove_dunfell = "virtual/kernel bridge-utils"
DEPENDS_append_class-target_dunfell = " virtual/kernel linux-marvell kernel-devsrc"
DEPENDS_append_class-target_dunfell = " bridge-utils"
EXTRA_OECONF += "--enable-ssl"

EXTRA_OECONF_class-target_dunfell += "--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH} PYTHON=python3 PYTHON3=python3 PERL=${bindir}/perl "

PV = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', '2.17+${SRCPV}', '2.13+${SRCPV}', d)}"
DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'linux-marvell kernel-devsrc', '', d)}"
EXTRA_OECONF_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', '--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH}', '', d)}"

# Bad idea, once meta-vitualization is corrected, then won't need this
SRC_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'file://python-switch-remaining-scripts-to-use-python3.patch file://systemd-update-tool-paths.patch file://systemd-create-runtime-dirs.patch', '', d)}"
SRC_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'git://github.com/openvswitch/ovs.git;protocol=https;branch=branch-2.13', '', d)}"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'git://github.com/openvswitch/ovs.git;protocol=https;branch=branch-2.17', '', d)}"
SRCREV = "${AUTOREV}"

#disable openvswitch autostart
SYSTEMD_SERVICE_${PN}-switch = ""
do_compile_prepend() {
        export CROSS_COMPILE=`echo '${TARGET_PREFIX}'`
}

PACKAGECONFIG[ssl] = " "
