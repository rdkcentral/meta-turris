SUMMARY = "OpenSource IEEE1905.1a implementation"
LICENSE = "BSD-2-Clause-Patent"
LIC_FILES_CHKSUM = "file://LICENSE;md5=edf4a061b3f292eb6b05e6a86269f954"

DEPENDS = "openssl libpcap"
S = "${WORKDIR}/git"

SRC_URI = "git://github.com/BroadbandForum/meshComms.git \
           file://0001-Added-support-for-RDK-flavour-compilation.patch \
           file://0002-Added-support-for-openssl-1.1.0-compilation.patch \
          "

SRC_URI[md5sum] = "d0ca2c6f7cdc80102f404b75f8563b0f"
SRC_URI[sha256sum] = "f9c8b5c3eba68b6cd4c8a92b07061487680d7d2ca93f1dcfe0093aa968e80389"

SRCREV = "a5b0121d046d1081c3e5d980644e93b206932ec9"

S = "${WORKDIR}/git"

CFLAGS_append = " \
                "

LDFLAGS_append = " \
    -lpthread \
    -lpcap \
    -lcrypto \
    -lrt \
    "

#force lib to be built first
do_compile () {
    PLATFORM=linux FLAVOUR=RDK make
}

do_install () {
    # Config files and scripts
    install -d ${D}/usr/bin
    install -m 555 ${S}/output/al_entity ${D}/${bindir}/al_entity
    install -m 555 ${S}/output/hle_entity ${D}/${bindir}/hle_entity
}

FILES_${PN} += "${bindir}/al_entity"
FILES_${PN} += "${bindir}/hle_entity"
