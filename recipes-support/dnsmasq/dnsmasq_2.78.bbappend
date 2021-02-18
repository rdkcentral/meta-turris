FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://300-vendor-class-dhcp-lease-file.patch', '', d)}"
