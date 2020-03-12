SUMMARY = "OpenvSwitch"
DESCRIPTION = "\
	Open vSwitch is a production quality, multilayer virtual switch \
	licensed under the open source Apache 2.0 license. It is designed \
	to enable massive network automation through programmatic extension, \
	while still supporting standard management interfaces and protocols \
	(e.g. NetFlow, sFlow, SPAN, RSPAN, CLI, LACP, 802.1ag) \
	"

HOMEPAGE = "http://openvswitch.org/"
SECTION = "networking"
LICENSE = "Apache-2"

DEPENDS += "openssl coreutils-native"

RDEPENDS_${PN} += "util-linux-uuidgen util-linux-libuuid coreutils \
        ${PN}-switch \
        bash "
RDEPENDS_${PN}-switch = "${PN} openssl procps util-linux-uuidgen"

# Some installers will fail because of an install order based on
# rdeps.  E.g. ovs-pki calls sed in the postinstall.  sed may be
# queued for install later.
RDEPENDS_${PN} += "sed gawk grep"

SRC_URI = "\
	file://openvswitch-switch \
	file://openvswitch-switch-setup \
	"

CONFIGUREOPT_DEPTRACK = ""

# Don't compile kernel modules by default since it heavily depends on
# kernel version. Use the in-kernel module for now.
# distro layers can enable with EXTRA_OECONF_pn_openvswitch += ""
#EXTRA_OECONF = "--with-linux=${STAGING_KERNEL_DIR} KARCH=${TARGET_ARCH}"

PACKAGES =+ "${PN}-switch"


FILES_${PN}-switch = "\
	${sysconfdir}/init.d/openvswitch-switch \
	${sysconfdir}/default/openvswitch-switch \
	${systemd_unitdir}/system/ovs-vswitchd.service \
	${systemd_unitdir}/system/openvswitch.service \
	${systemd_unitdir}/system/ovsdb-server.service \
	${sysconfdir}/sysconfig/openvswitch \
	${sysconfdir}/openvswitch/default.conf \
	"

# silence a warning
FILES_${PN} += "${datadir}/ovsdbmonitor"
FILES_${PN} += "/run"

inherit autotools update-rc.d systemd

#SYSTEMD_PACKAGES = "${PN}-switch"
#SYSTEMD_SERVICE_${PN}-switch = " \
#    ovsdb-server.service \
#    ovs-vswitchd.service \
#    openvswitch.service \
#"

INITSCRIPT_PACKAGES = "${PN}-switch"
INITSCRIPT_NAME_${PN}-switch = "openvswitch-switch"
INITSCRIPT_PARAMS_${PN}-switch = "defaults 71"

do_compile_prepend() {

	export CROSS_COMPILE=arm-rdk-linux-musleabi-
}

do_configure_prepend() {
	# Work around the for Makefile CC=$(if ....) by swapping out any
	# "-Wa," assembly directives with "-Xassembler
	CC=`echo '${CC}' | sed 's/-Wa,/-Xassembler /g'`
}

do_install_prepend() {
	SERVICE_FILE="${S}/rhel/usr_lib_systemd_system_ovs-vswitchd.service"
	${S}/build-aux/dpdkstrip.py \
	    ${@bb.utils.contains('PACKAGECONFIG','dpdk','--dpdk','--nodpdk',d)} \
	    < ${S}/rhel/usr_lib_systemd_system_ovs-vswitchd.service.in \
	    > ${SERVICE_FILE}
}

do_install_append() {
	install -d ${D}/${sysconfdir}/default/
	install -m 660 ${WORKDIR}/openvswitch-switch-setup ${D}/${sysconfdir}/default/openvswitch-switch

	install -d ${D}/${sysconfdir}/init.d/
	install -m 755 ${WORKDIR}/openvswitch-switch ${D}/${sysconfdir}/init.d/openvswitch-switch
	true || rm -fr ${D}/${datadir}/${PN}/pki

	install -d ${D}/${sysconfdir}/sysconfig
	install -m 644 ${S}/rhel/usr_share_openvswitch_scripts_systemd_sysconfig.template \
		${D}/${sysconfdir}/sysconfig/openvswitch

	install -d ${D}/${sysconfdir}/openvswitch
	install -m 644 ${S}/rhel/etc_openvswitch_default.conf \
		${D}/${sysconfdir}/openvswitch/default.conf

	install -d ${D}/${systemd_unitdir}/system/
	install -m 644 ${S}/rhel/usr_lib_systemd_system_ovs-vswitchd.service \
		${D}/${systemd_unitdir}/system/ovs-vswitchd.service
	install -m 644 ${S}/rhel/usr_lib_systemd_system_openvswitch.service \
		${D}/${systemd_unitdir}/system/openvswitch.service
	install -m 644 ${S}/rhel/usr_lib_systemd_system_ovsdb-server.service \
		${D}/${systemd_unitdir}/system/ovsdb-server.service

	install -d ${D}/usr/share/openvswitch/scripts/
	install -m 755 ${S}/rhel/usr_share_openvswitch_scripts_ovs-systemd-reload ${D}/usr/share/openvswitch/scripts/ovs-systemd-reload

	oe_runmake modules_install INSTALL_MOD_PATH=${D}
}


