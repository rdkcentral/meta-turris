
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'openvswitch openvswitch-native', '', d)}"
RDEPENDS_${PN}_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'kernel5.x', 'openvswitch', '', d)}"


do_patch[postfuncs] += "fix_turris_arch"

fix_turris_arch() {
  # Mutiple values in filter will return mutiple values, so avoid repeted values
  if [ "x`grep "filter.*RDK_MACHINE.*${MACHINE_ARCH} " ${S}/vendor/turris/build/vendor-arch.mk`" = "x" ]; then
     sed -i -e "s/\(filter.*RDK_MACHINE.,\)/\1${MACHINE_ARCH} /g"  ${S}/vendor/turris/build/vendor-arch.mk
  fi
}

