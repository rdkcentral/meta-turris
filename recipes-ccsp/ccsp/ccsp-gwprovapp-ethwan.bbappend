require ccsp_common_turris.inc

DEPENDS_remove = " ruli"    

export PLATFORM_TURRIS_ENABLED="yes"

inherit systemd

do_install_append () {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${S}/service/gwprovethwan.service ${D}${systemd_unitdir}/system
        sed -i "s/After=rg_network.service/After=network.target/g"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/After=network.target/a wants=network.target"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -e '/Type/ s/^#*/#/' -i  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -e '/ExecStartPre/ s/^#*/#/' -i  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/utopia_init.sh/a ExecStartPre=-/bin/sh -c 'mkdir -p /rdklogs/logs/'"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -e '/ExecStartPost/ s/^#*/#/' -i  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/bin\/rm/a Restart=always"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "s/StandardOutput=syslog/StandardOutput=syslog+console/g"  ${D}${systemd_unitdir}/system/gwprovethwan.service
}

SYSTEMD_SERVICE_${PN} = "gwprovethwan.service"
FILES_${PN} += " \
     ${systemd_unitdir}/system/gwprovethwan.service \
"
