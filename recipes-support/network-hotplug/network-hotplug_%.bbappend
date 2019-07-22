FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://turris-network-hotplug.patch;patchdir=${WORKDIR}/ \
           "
