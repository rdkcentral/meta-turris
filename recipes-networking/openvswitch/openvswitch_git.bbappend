DEPENDS_remove_dunfell = "virtual/kernel bridge-utils"
DEPENDS_append_class-target_dunfell = " virtual/kernel linux-marvell kernel-devsrc"
DEPENDS_append_class-target_dunfell = " bridge-utils"
EXTRA_OECONF += "--enable-ssl"

EXTRA_OECONF_class-target_dunfell += "--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH} PYTHON=python3 PYTHON3=python3 PERL=${bindir}/perl "

PV:turris5.10 = "2.17+${SRCPV}"
DEPENDS_remove_turris5.10 += "linux-marvell kernel-devsrc"
EXTRA_OECONF_remove_turris5.10 += "--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH} "

# Bad idea, once meta-vitualization is corrected, then won't need this
SRC_URI_remove_turris5.10 += " file://python-switch-remaining-scripts-to-use-python3.patch file://systemd-update-tool-paths.patch file://systemd-create-runtime-dirs.patch"
SRC_URI_remove_turris5.10 += " git://github.com/openvswitch/ovs.git;protocol=https;branch=branch-2.13 "
SRC_URI_append_turris5.10 += "git://github.com/openvswitch/ovs.git;protocol=https;branch=branch-2.17"
SRCREV_turris5.10 = "${AUTOREV}"

#disable openvswitch autostart
SYSTEMD_SERVICE_${PN}-switch = ""
do_compile_prepend() {
        export CROSS_COMPILE=`echo '${TARGET_PREFIX}'`
}

PACKAGECONFIG[ssl] = " "
