FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://lighttpd_php.conf.broadband \
    file://lighttpd_jst.conf.broadband \
"

SYSTEMD_SERVICE_${PN} += "lighttpd.service"

do_install_append() {
    install -d ${D}${sysconfdir}
    if [ "${@bb.utils.contains("DISTRO_FEATURES", "webui_jst", "yes", "no", d)}" = "yes" ]; then
       install -m 0644 ${WORKDIR}/lighttpd_jst.conf.broadband ${D}${sysconfdir}/lighttpd.conf
    else       
       install -m 0644 ${WORKDIR}/lighttpd_php.conf.broadband ${D}${sysconfdir}/lighttpd.conf
    fi

    sed -i '/mod_redirect/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \"mod_openssl\",' ${D}/${sysconfdir}/lighttpd.conf
    echo "include_shell \"sh /etc/webgui_config.sh\"" >> ${D}/${sysconfdir}/lighttpd.conf
}

FILES_${PN}_append_morty = " /usr/lib/mod_fastcgi.so"

RDEPENDS_${PN}_append_dunfell = " \
    lighttpd-module-fastcgi \
    lighttpd-module-proxy \
    " 
