SUMMARY = "OpenSource IEEE1905.1a implementation"
LICENSE = "BSD-2-Clause-Patent"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9cbc6eb40e7e82d67fbbce1734e6622b"

DEPENDS = "openssl libpcap multiap-platform"
S = "${WORKDIR}/git"

SRC_URI = "git://github.com/TechnicolorEDGM/ieee1905.git;protocol=https \
           file://0001-Added-support-for-RDK-flavour-compilation.patch \
          "
#rdk-port: <TBD> need to apply following patch accordingly
#           file://0002-Added-support-for-openssl-1.1.0-compilation.patch

SRC_URI[md5sum] = "d0ca2c6f7cdc80102f404b75f8563b0f"
SRC_URI[sha256sum] = "f9c8b5c3eba68b6cd4c8a92b07061487680d7d2ca93f1dcfe0093aa968e80389"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

CFLAGS_append = " \
                "

LDFLAGS_append = " \
    -lpthread \
    -lpcap \
    -lcrypto \
    -lrt \
    "

do_compile () {
    PLATFORM=linux FLAVOUR=RDK make
}

do_install () {
    # Installing header files and binaries
    install -d ${D}${includedir}
    install -m 0644 ${B}/src/al/src_independent/extensions/map/1905_lib.h ${D}${includedir}/1905_lib.h
    install -d ${D}${bindir}
    install -m 555 ${S}/output/al_entity ${D}/${bindir}/al_entity
    install -m 555 ${S}/output/hle_entity ${D}/${bindir}/hle_entity
}

#Not installing for now
#IMAGE_INSTALL += " ieee1905"

FILES_${PN} += "${bindir}/al_entity"
FILES_${PN} += "${bindir}/hle_entity"
