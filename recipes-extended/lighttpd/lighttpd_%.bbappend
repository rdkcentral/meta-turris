FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://lighttpd.conf.broadband"

SYSTEMD_SERVICE_${PN} += "lighttpd.service"

LIGHTTPDCONF = "lighttpd.conf.broadband"
do_install_append() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/${LIGHTTPDCONF} ${D}${sysconfdir}/lighttpd.conf
}

FILES_${PN}_append_morty = " /usr/lib/mod_fastcgi.so"

RDEPENDS_${PN}_append_dunfell = " \
    lighttpd-module-fastcgi \
    lighttpd-module-proxy \
    " 
