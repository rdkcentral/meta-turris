require ccsp_common_turris.inc

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

LDFLAGS += " -lbreakpadwrapper \
             -lsyscfg \
           "
LDFLAGS_append_dunfell = " -lpthread"
