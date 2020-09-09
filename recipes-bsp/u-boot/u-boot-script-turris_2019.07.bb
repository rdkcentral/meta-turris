LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;md5=1272cbaf65c82bebc49d21637dbcb74b"
DEPENDS = "u-boot-mkimage-native"

SRC_URI = "file://bootscript \
	   file://README"

S = "${WORKDIR}/"

inherit deploy

BOOTSCRIPT = "${S}/bootscript"
FILES_${PN} += "/boot.scr"
FILES_${PN} += "/boot-main.scr"
FILES_${PN} += "/boot-alt.scr"

do_mkimage () {
    uboot-mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
                  -n "boot script" -d ${BOOTSCRIPT} ${S}/boot.scr
    cp ${S}/boot.scr ${S}/boot-main.scr
    sed -i 's|/dev/mmcblk0p2|/dev/mmcblk0p3|' ${BOOTSCRIPT}
    uboot-mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
                  -n "boot script" -d ${BOOTSCRIPT} ${S}/boot-alt.scr
}

addtask mkimage after do_compile before do_install

do_deploy () {
    install -d ${DEPLOYDIR}
    install ${S}/boot*.scr \
            ${DEPLOYDIR}/

    cd ${DEPLOYDIR}
    mv boot.scr boot.scr-${MACHINE}-${PV}-${PR}
    ln -sf boot.scr-${MACHINE}-${PV}-${PR} boot.scr-${MACHINE}
    ln -sf boot.scr-${MACHINE}-${PV}-${PR} boot.scr

}

do_install () {
    install ${S}/boot*.scr ${D}/
}

addtask deploy after do_install before do_build

do_compile[noexec] = "1"

PROVIDES += "u-boot-script"
RPROVIDES_${PN} += "u-boot-script"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "turris"
