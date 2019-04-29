DEPENDS_remove = "ucresolv"
LDFLAGS_remove = "-lucresolv"

CFLAGS_remove = "-I${STAGING_INCDIR}/ucresolv"
CFLAGS_remove = "-DFEATURE_DNS_QUERY"

EXTRA_OECMAKE_remove = "-DFEATURE_DNS_QUERY=true"
