require ccsp_common_turris.inc

LDFLAGS_append_dunfell = " -lsafec-3.5.1"
EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
