EXTRA_OECONF += " \
		--without-pear  \
		"
do_install_prepend_pn-php () {
	install -d ${D}${sysconfdir}
        touch ${D}${sysconfdir}/pear.conf
}

do_install_append_pn-php () {
    rm ${D}${sysconfdir}/pear.conf
}
