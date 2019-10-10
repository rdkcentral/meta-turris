SRC_URI += "${CMF_GIT_ROOT}/rdk/devices/raspberrypi/webpa-client;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/devices;name=rdkbturris"

SRCREV_rdkbturris = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_rdkbturris"
SRCREV_FORMAT .= "_rdkbturris"

inherit systemd

EXTRA_OECMAKE += "-DBUILD_RASPBERRYPI=ON "

LDFLAGS_remove_morty = " -lpthread"

do_install_append_broadband () {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${base_libdir_native}/rdk
    install -m 0644 ${S}/devices/broadband/parodus2ccsp/systemd/webpabroadband.service ${D}${systemd_unitdir}/system
    install -m 0755 ${S}/devices/broadband/parodus2ccsp/scripts/webpa_pre_setup.sh ${D}${base_libdir_native}/rdk
}

SYSTEMD_SERVICE_${PN}_append = " webpabroadband.service"

FILES_${PN}_append = " \
     ${systemd_unitdir}/system/webpabroadband.service \
     ${base_libdir_native}/rdk/* \
     "
