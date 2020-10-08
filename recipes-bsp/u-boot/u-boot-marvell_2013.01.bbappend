B = "${S}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
 
SRC_URI_append = " file://u-boot-inline-error.patch \
           "
do_configure_prepend_dunfell() {
touch ${S}/.config
touch ${S}/u-boot-initial-env
cp ${WORKDIR}/recipe-sysroot-native/usr/bin/oldconfig ${WORKDIR}/uboot/oldconfig
}
