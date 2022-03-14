do_install_append () {
sed -i "s/#net\/ipv4\/ip_forward=1/net\/ipv4\/ip_forward=1/g" ${D}/etc/sysctl.conf
}

