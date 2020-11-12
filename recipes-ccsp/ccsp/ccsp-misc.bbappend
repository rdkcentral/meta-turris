require ccsp_common_turris.inc

DEPENDS += "utopia"
DEPENDS_append_dunfell = " ccsp-lm-lite"

LDFLAGS_append = " -lutapi -lutctx"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
