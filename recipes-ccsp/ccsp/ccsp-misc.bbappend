require ccsp_common_turris.inc

DEPENDS += "utopia"

LDFLAGS_append = " -lutapi -lutctx"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
