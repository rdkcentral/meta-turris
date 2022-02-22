FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require ccsp_common_turris.inc

export PLATFORM_TURRIS_ENABLED="yes"

FILES_${PN} += " \
    /usr/bin/gw_prov_utopia \
"
