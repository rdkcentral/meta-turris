require ccsp_common_turris.inc

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

LDFLAGS_append =" \
    -lsyscfg \
    -lbreakpadwrapper \
"
