require ccsp_common_turris.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LDFLAGS_append = " -Wl,--no-as-needed"

SRC_URI += "file://musl-header-missing.patch"
