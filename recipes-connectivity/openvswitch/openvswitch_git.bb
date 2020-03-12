require openvswitch.inc

#DEPENDS += "virtual/kernel"

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}/git"
PV = "2.11+${SRCPV}"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}-git:"

SRCREV = "f22ca8011fdb7e81ffce5017cd26539bccf50e94"
SRC_URI = "file://openvswitch-switch \
           file://openvswitch-switch-setup \
           git://github.com/openvswitch/ovs.git;protocol=git;branch=branch-2.11 \
           file://disable_m4_check.patch \
           file://kernel_module.patch \
           file://0002-Define-WAIT_ANY-if-not-provided-by-system.patch \
           file://systemd-update-tool-paths.patch \
           file://systemd-create-runtime-dirs.patch \
           file://disable-unused-utils.patch \
           "

LIC_FILES_CHKSUM = "file://LICENSE;md5=1ce5d23a6429dff345518758f13aaeab"


#PACKAGECONFIG ?= "libcap-ng"
#PACKAGECONFIG[libcap-ng] = "--enable-libcapng,--disable-libcapng,libcap-ng,"
#PACKAGECONFIG[ssl] = ",--disable-ssl,openssl,"

# Don't compile kernel modules by default since it heavily depends on
# kernel version. Use the in-kernel module for now.
# distro layers can enable with EXTRA_OECONF_pn_openvswitch += ""
#EXTRA_OECONF_turris-extender += "--with-linux=${STAGING_KERNEL_BUILDDIR} --with-linux-source=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH}"

# silence a warning
FILES_${PN} += "/lib/modules"


#EXTRA_OEMAKE += "TEST_DEST=${D}${PTEST_PATH} TEST_ROOT=${PTEST_PATH}"


do_install_append() {
	oe_runmake modules_install INSTALL_MOD_PATH=${D}
}
