# Note that RDK-B builds typically require hostapd and wpa-supplicant, which
# both contain hardcoded dependencies on MD4 support being enabled in openssl.
# RDK-B specific OEM layers may therefore require an additional .bbappend for
# openssl which sets:

#EXTRA_OECONF_remove_class-target = "no-md4"

# Keep the complete over-ride for native builds. Temp solution, to be removed
# once meta-rdk-ext .bbappend for openssl is updated to append RDK specific
# config options to the target build only.
# Fix for building python-m2crypto-native.

#Commenting following line because of openssl-native build (linking) issue
#EXTRA_OECONF_class-native = "-no-ssl3"
