DEPENDS_remove = "ucresolv"
LDFLAGS_remove = "-lucresolv"

CFLAGS_remove = "-I${STAGING_INCDIR}/ucresolv"
CFLAGS_remove = "-DFEATURE_DNS_QUERY"

EXTRA_OECMAKE_remove = "-DFEATURE_DNS_QUERY=true"

inherit systemd coverity


FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://parodus.service"
SRC_URI += "file://parodus_start.sh"

do_install_append_broadband () {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${base_libdir_native}/rdk
    install -m 0644 ${WORKDIR}/parodus.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/parodus_start.sh ${D}${base_libdir_native}/rdk
}

SYSTEMD_SERVICE_${PN}_append_broadband = " parodus.service"

FILES_${PN}_append_broadband = " \
     ${systemd_unitdir}/system/parodus.service \
     ${base_libdir_native}/rdk/* \
"
