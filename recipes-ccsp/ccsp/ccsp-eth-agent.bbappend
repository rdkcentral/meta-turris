require ccsp_common_turris.inc

LDFLAGS += " -lbreakpadwrapper \
             -lsyscfg \
           "
LDFLAGS_append_dunfell = " -lpthread"
