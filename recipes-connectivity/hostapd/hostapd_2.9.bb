SUMMARY = "User space daemon for extended IEEE 802.11 management"
HOMEPAGE = "http://w1.fi/hostapd/"
SECTION = "kernel/userland"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://hostapd/README;md5=1ec986bec88070e2a59c68c95d763f89"

DEPENDS = "libnl openssl"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'telemetry2_0', 'telemetry', '', d)}"
LDFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'telemetry2_0', ' -ltelemetry_msgsender ', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = " \
    http://w1.fi/releases/hostapd-${PV}.tar.gz \
    file://hostapd-enable-80211ac.patch;patchdir=${WORKDIR}/ \
    file://hostapd_turris.patch \
    file://defconfig \
    file://hostapd-2G.conf \
    file://hostapd-5G.conf \
    file://hostapd-bhaul2G.conf \
    file://hostapd-bhaul5G.conf \
    file://hostapd.service \
    file://hostapd-init.sh \
"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://c89daaeca4ee90c8bc158e37acb1b679c823d7ab.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://nl80211-relax-bridge-setup.patch', '', d)}"

SRC_URI[md5sum] = "f188fc53a495fe7af3b6d77d3c31dee8"
SRC_URI[sha256sum] = "881d7d6a90b2428479288d64233151448f8990ab4958e0ecaca7eeb3c9db2bd7"

S = "${WORKDIR}/hostapd-${PV}"
B = "${WORKDIR}/hostapd-${PV}/hostapd"

inherit update-rc.d systemd
INITSCRIPT_NAME = "hostapd"

SYSTEMD_AUTO_ENABLE_${PN} = "enable"
SYSTEMD_SERVICE_${PN} = "hostapd.service"

do_configure_append() {
    install -m 0644 ${WORKDIR}/defconfig ${B}/.config
}

do_compile() {
    export CFLAGS="-MMD -O2 -Wall -g -I${STAGING_INCDIR}/libnl3"
    export EXTRA_CFLAGS="${CFLAGS}"
    make V=1
}

do_install() {
         install -d ${D}${sbindir} ${D}${sysconfdir} ${D}${systemd_unitdir}/system/ ${D}${base_libdir}/rdk
         install -m 0755 ${B}/hostapd ${D}${sbindir}
         install -m 0755 ${B}/hostapd_cli ${D}${sbindir}
         install -m 0644 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system
         install -m 0755 ${WORKDIR}/hostapd-init.sh ${D}${base_libdir}/rdk
}

do_install_turris-extender() {
         install -d ${D}${sbindir} ${D}${sysconfdir} ${D}${systemd_unitdir}/system/ ${D}${base_libdir}/rdk
         install -m 0755 ${B}/hostapd ${D}${sbindir}
         install -m 0755 ${B}/hostapd_cli ${D}${sbindir}
         sed -i 's/bridge=brlan0/bridge=br-home/' ${WORKDIR}/hostapd-2G.conf
         sed -i 's/bridge=brlan0/bridge=br-home/' ${WORKDIR}/hostapd-5G.conf
         sed -i '/^After=CcspPandMSsp.service/d' ${WORKDIR}/hostapd.service
         sed -i '/^ExecStart=/c\ExecStart=/usr/sbin/hostapd -g /var/run/hostapd/global -B -P /var/run/hostapd-global.pid' ${WORKDIR}/hostapd.service
         install -m 0644 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system
         install -m 0755 ${WORKDIR}/hostapd-init.sh ${D}${base_libdir}/rdk
}

FILES_${PN} += " \
                ${systemd_unitdir}/system/hostapd.service \
                ${sysconfdir}/hostapd-2G.conf \
                ${sysconfdir}/hostapd-5G.conf \
                ${sysconfdir}/hostapd-bhaul2G.conf \
                ${sysconfdir}/hostapd-bhaul5G.conf \
                ${base_libdir}/rdk/hostapd-init.sh \
"
