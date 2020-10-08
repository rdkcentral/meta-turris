DEPENDS_remove_dunfell = "virtual/kernel bridge-utils"
DEPENDS_append_class-target_dunfell = " virtual/kernel"
DEPENDS_append_class-target_dunfell = " bridge-utils"

EXTRA_OECONF += "--enable-ssl"

#disable openvswitch autostart
SYSTEMD_SERVICE_${PN}-switch = ""

PACKAGECONFIG[ssl] = " "
