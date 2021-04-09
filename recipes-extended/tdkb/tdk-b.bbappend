EXTRA_OECONF_append = " --enable-ert --enable-platform"

SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/turris/tdkb;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/platform/turris;name=tdkbturris"

SRCREV_tdkturris = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_tdkbturris"
SRCREV_FORMAT = "tdk_tdkbturris"

do_install_append () {
    install -d ${D}${tdkdir}
    install -d ${D}/etc
    install -p -m 755 ${S}/platform/turris/agent/scripts/*.sh ${D}${tdkdir}
    install -p -m 755 ${S}/platform/turris/agent/scripts/tdk_platform.properties ${D}/etc/
}

FILES_${PN} += "${prefix}/ccsp/"
FILES_${PN} += "/etc/*"
FILES_${PN} += "${tdkdir}/*"

