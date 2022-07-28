DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'openvswitch openvswitch-native', '', d)}"
RDEPENDS_${PN}_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'openvswitch', '', d)}"
