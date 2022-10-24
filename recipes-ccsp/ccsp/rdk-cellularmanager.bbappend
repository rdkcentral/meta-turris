do_configure_prepend() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_cellular_manager', 'true', 'false', d)}; then
        (python ${STAGING_BINDIR_NATIVE}/dm_pack_code_gen.py ${S}/config/RdkCellularManager.xml ${S}/source/CellularManager/dm_pack_datamodel.c)
    fi
}
