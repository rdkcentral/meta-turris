do_install_append_broadband () {
	# deal with hostname
	if [ "${hostname}" ]; then
		echo "TurrisOmnia-GW" > ${D}${sysconfdir}/hostname
		echo "127.0.1.1 TurrisOmnia-GW" >> ${D}${sysconfdir}/hosts
	fi
}
