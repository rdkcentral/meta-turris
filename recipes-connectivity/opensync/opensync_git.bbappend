FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
OPENSYNC_VENDOR_URI += "file://turris-bci-target.patch;patchdir=${WORKDIR}/git/vendor/turris"
OPENSYNC_SERVICE_PROVIDER_URI += " ${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://0001-Update-bhaul-credential.patch;patchdir=${WORKDIR}/git/service-provider/local', '', d)} "
