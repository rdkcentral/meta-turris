SUMMARY = "User space daemon for extended IEEE 802.11 management"
HOMEPAGE = "http://w1.fi/hostapd/"
SECTION = "kernel/userland"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://hostapd/README;md5=c905478466c90f1cefc0df987c40e172"

DEPENDS = "libnl openssl"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'telemetry2_0', 'telemetry', '', d)}"
LDFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'telemetry2_0', ' -ltelemetry_msgsender ', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = " \
    http://w1.fi/releases/hostapd-${PV}.tar.gz \
    file://defconfig \
    file://hostapd-2G.conf \
    file://hostapd-5G.conf \
    file://hostapd-open2G.conf \
    file://hostapd-open5G.conf \
    file://hostapd-bhaul2G.conf \
    file://hostapd-bhaul5G.conf \
    file://hostapd.service \
    file://hostapd-init.sh \
"

SRC_URI[md5sum] = "0be43e9e09ab94a7ebf82de0d1c57761"
SRC_URI[sha256sum] = "206e7c799b678572c2e3d12030238784bc4a9f82323b0156b4c9466f1498915d"

SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', 'file://hostapd-6G.conf', '', d)}"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', 'file://hostapd-bhaul6G.conf', '', d)}"

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
         install -m 0644 ${WORKDIR}/hostapd-open2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-open5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system
         install -m 0755 ${WORKDIR}/hostapd-init.sh ${D}${base_libdir}/rdk
         if ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', 'true', 'false', d)}; then
            install -m 0644 ${WORKDIR}/hostapd-6G.conf ${D}${sysconfdir}
            install -m 0644 ${WORKDIR}/hostapd-bhaul6G.conf ${D}${sysconfdir}
         fi
}

do_install_turris-extender() {
         install -d ${D}${sbindir} ${D}${sysconfdir} ${D}${systemd_unitdir}/system/ ${D}${base_libdir}/rdk
         install -m 0755 ${B}/hostapd ${D}${sbindir}
         install -m 0755 ${B}/hostapd_cli ${D}${sbindir}
         sed -i '/^After=CcspPandMSsp.service/d' ${WORKDIR}/hostapd.service
         sed -i '/^ExecStart=/c\ExecStart=/usr/sbin/hostapd -g /var/run/hostapd/global -B -P /var/run/hostapd-global.pid' ${WORKDIR}/hostapd.service
         install -m 0644 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-open2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-open5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-bhaul5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system
         install -m 0755 ${WORKDIR}/hostapd-init.sh ${D}${base_libdir}/rdk
         if ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', 'true', 'false', d)}; then
            install -m 0644 ${WORKDIR}/hostapd-6G.conf ${D}${sysconfdir}
            install -m 0644 ${WORKDIR}/hostapd-bhaul6G.conf ${D}${sysconfdir}
         fi
}

FILES_${PN} += " \
                ${systemd_unitdir}/system/hostapd.service \
                ${sysconfdir}/hostapd-2G.conf \
                ${sysconfdir}/hostapd-5G.conf \
                ${sysconfdir}/hostapd-open2G.conf \
                ${sysconfdir}/hostapd-open5G.conf \
                ${sysconfdir}/hostapd-bhaul2G.conf \
                ${sysconfdir}/hostapd-bhaul5G.conf \
                ${base_libdir}/rdk/hostapd-init.sh \
"

FILES_${PN}_append = " \
                ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', '${sysconfdir}/hostapd-6G.conf', '', d)} \
                ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', '${sysconfdir}/hostapd-bhaul6G.conf', '', d)} \
"
