EXTRA_OECONF += " --enable-obsolete-rpc" 

#avoiding the conflicts with libnsl2
do_install_append_dunfell() {
rm -rf ${D}/usr/include/rpcsvc
}

