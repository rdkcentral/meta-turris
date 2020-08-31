SUMMARY = "WIFI HAL for RDK CCSP components"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=cc44d3d0bd3fb4f1a5b6f235c8c326c0"

PROVIDES = "hal-wifi"
RPROVIDES_${PN} = "hal-wifi"

inherit autotools coverity

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "${CMF_GITHUB_ROOT}/rdkcentral/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};name=wifihal"
SRCREV_wifihal = "${AUTOREV}"
SRCREV_FORMAT = "wifihal"

PV = "${RDK_RELEASE}+git${SRCPV}"
S = "${WORKDIR}/git/source/wifi/"

DEPENDS += "halinterface libnl libev hostapd wpa-supplicant"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'extender', '-D_TURRIS_EXTENDER_', '', d)}"
CFLAGS_append = " -I=${includedir}/ccsp -I=${includedir}/libnl3"
LDFLAGS_append = " -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3 -lev -lwpa_client"

RDEPENDS_${PN}_dunfell += " wpa-supplicant"
