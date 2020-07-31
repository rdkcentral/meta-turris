require ccsp_common_turris.inc

LDFLAGS += " -lbreakpadwrapper \
             -lsyscfg \
           "
LDFLAGS_append_dunfell = " -lpthread"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
