DEPENDS_remove_dunfell = "virtual/kernel bridge-utils"
DEPENDS_append_class-target_dunfell = " virtual/kernel linux-marvell kernel-devsrc"
DEPENDS_append_class-target_dunfell = " bridge-utils"
EXTRA_OECONF += "--enable-ssl"

EXTRA_OECONF_class-target_dunfell += "--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH} PYTHON=python3 PYTHON3=python3 PERL=${bindir}/perl "

#disable openvswitch autostart
SYSTEMD_SERVICE_${PN}-switch = ""
do_compile_prepend() {
        export CROSS_COMPILE=`echo '${TARGET_PREFIX}'`
}

PACKAGECONFIG[ssl] = " "
