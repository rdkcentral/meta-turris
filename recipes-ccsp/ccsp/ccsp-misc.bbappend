require ccsp_common_turris.inc

DEPENDS_append_dunfell = " ccsp-lm-lite"

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
