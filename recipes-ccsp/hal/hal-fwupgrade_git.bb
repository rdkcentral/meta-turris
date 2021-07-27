SUMMARY = "HAL for RDK CCSP components"
HOMEPAGE = "http://github.com/belvedere-yocto/hal"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=cc44d3d0bd3fb4f1a5b6f235c8c326c0"

PROVIDES = "hal-fwupgrade"
RPROVIDES_${PN} = "hal-fwupgrade"

DEPENDS += "halinterface"
SRC_URI = "${CMF_GITHUB_ROOT}/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MASTER_BRANCH};name=fwupgradehal"

SRCREV_fwupgradehal = "${AUTOREV}"
SRCREV_FORMAT = "fwupgradehal"

PV = "${RDK_RELEASE}+git${SRCPV}"

S = "${WORKDIR}/git/source/fwupgrade"

CFLAGS_append = " -I=${includedir}/ccsp "

inherit autotools coverity

