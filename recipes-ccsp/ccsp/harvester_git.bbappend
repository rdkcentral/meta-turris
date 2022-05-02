CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'halVersion3', ' -DWIFI_HAL_VERSION_3 ', '', d)}"
