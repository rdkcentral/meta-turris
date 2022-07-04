FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


do_configure_prepend () {

 sed -i -e  '$ a ln -s $DHCP_CONFIG_FILE_TMP $DHCP_CONFIG_FILE'  ${WORKDIR}/prepare_dhcpv6_config.sh
 touch  ${WORKDIR}/SED_APPLIED
}
