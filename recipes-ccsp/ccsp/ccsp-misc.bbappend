require ccsp_common_turris.inc

DEPENDS += "utopia"

LDFLAGS_append = " -lutapi -lutctx"
