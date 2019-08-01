require ccsp_common_turris.inc

LDFLAGS_append = " -Wl,--no-as-needed"

SRC_URI += "file://lmlite-avoid-l2sd0-check.patch"
