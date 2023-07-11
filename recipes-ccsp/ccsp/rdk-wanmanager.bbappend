FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://udhcpc_check.sh \
"

do_compile_prepend () {
    (python ${STAGING_BINDIR_NATIVE}/dm_pack_code_gen.py ${S}/config/RdkWanManager.xml ${S}/source/WanManager/dm_pack_datamodel.c)
}

do_install_append(){
    # Config files and scripts
    install -d ${D}/lib/rdk
    install -m 777 ${WORKDIR}/udhcpc_check.sh ${D}/lib/rdk
}

FILES_${PN} += " ${base_libdir}/rdk/*" 
