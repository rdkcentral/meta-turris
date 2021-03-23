#To avoid build error due to RDKALL-2546
do_install_append_broadband_dunfell () {
	rm ${D}/usr/include/rbus-core
}
