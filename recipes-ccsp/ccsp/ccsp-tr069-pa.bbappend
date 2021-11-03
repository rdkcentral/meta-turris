FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require ccsp_common_turris.inc
LDFLAGS += "-Wl,--no-as-needed -lulog"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

LDFLAGS_append_dunfell = " -lsafec-3.5.1 -lcrypto"

do_install_append () {
    # Config files and scripts
    install -m 644 ${S}/config/ccsp_tr069_pa_certificate_cfg_arm.xml ${D}/usr/ccsp/tr069pa/ccsp_tr069_pa_certificate_cfg.xml
    install -m 644 ${S}/config/ccsp_tr069_pa_cfg_arm.xml ${D}/usr/ccsp/tr069pa/ccsp_tr069_pa_cfg.xml
    install -m 644 ${S}/config/ccsp_tr069_pa_mapper_arm.xml ${D}/usr/ccsp/tr069pa/ccsp_tr069_pa_mapper.xml
    install -m 644 ${S}/config/sdm_arm.xml ${D}/usr/ccsp/tr069pa/sdm.xml
    install -m 644 ${S}/arch/intel_usg/config/url ${D}/usr/ccsp/tr069pa/url

    install -d ${D}/fss/gw/
    install -d ${D}/fss/gw/usr/ccsp/
    install -d ${D}/etc
    install -m 777 ${D}/usr/bin/CcspTr069PaSsp -t ${D}/usr/ccsp/tr069pa

    ln -sf /version.txt ${D}/fss/gw/version.txt
    ln -sf /usr/ccsp/tr069pa/ ${D}/fss/gw/usr/ccsp/tr069pa
    ln -sf /usr/ccsp/tr069pa/sdm.xml ${D}/usr/bin/sdm.xml
    ln -sf /usr/ccsp/tr069pa/url ${D}${sysconfdir}/url
    echo "5555" > ${D}/usr/ccsp/tr069pa/sharedkey
}

FILES_${PN}-ccsp += " \
    ${prefix}/ccsp/tr069pa/CcspTr069PaSsp \
"

FILES_${PN} += " \
    /fss/gw/usr/ccsp/ \
    /fss/gw/version.txt \
    /etc/url \
"

do_package_qa(){
}
