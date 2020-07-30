FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://armada_38x_defconfig"
SRC_URI += "file://fw_env.config"

do_configure_prepend () {
    cp ${WORKDIR}/armada_38x_defconfig ${S}/configs/
}

do_install_append () {
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}

