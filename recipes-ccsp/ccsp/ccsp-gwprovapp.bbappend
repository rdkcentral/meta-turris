FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require ccsp_common_turris.inc

SRC_URI += " file://turris-macro-gwprov.patch"

DEPENDS_remove = " ruli"

export PLATFORM_TURRIS_ENABLED="yes"

FILES_${PN} += " \
    /usr/bin/gw_prov_utopia \
"
