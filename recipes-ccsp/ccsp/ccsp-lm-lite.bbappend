require ccsp_common_turris.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LDFLAGS_append = " -Wl,--no-as-needed"

SRC_URI += "file://lmlite-avoid-l2sd0-check.patch"
SRC_URI += "file://0001-ethwan-with-lmlite.patch"
SRC_URI += "file://musl-header-missing.patch"
