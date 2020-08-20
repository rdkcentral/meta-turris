DEPENDS_remove = "virtual/kernel bridge-utils"
DEPENDS_append_class-target = " virtual/kernel"
DEPENDS_append_class-target = " bridge-utils"

EXTRA_OECONF += "--enable-ssl"

#disable openvswitch autostart
SYSTEMD_SERVICE_${PN}-switch = ""

#PACKAGECONFIG_remove = "ssl"
PACKAGECONFIG[ssl] = " "
