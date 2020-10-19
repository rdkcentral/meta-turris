FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://dnsmasq.conf"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://300-vendor-class-dhcp-lease-file.patch', '', d)}"
