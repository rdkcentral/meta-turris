FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CORE_URI = "git://git@github.com/plume-design/opensync.git;protocol=ssh;branch=osync_1.2.1;name=core;destsuffix=git/core \
            file://0001-BM-Fix-compilation-errors.patch \
            file://0002-DIRTY-HACK-Fix-syntax-error-around-__GNUC_PREREQ.patch \
            "
VENDOR_URI = "git://git@github.com/plume-design/opensync-vendor-rdk-template.git;protocol=ssh;branch=osync_1.2.1_1;name=vendor;destsuffix=git/vendor/turris \
              file://0001-Added-Turris-omnia-support.patch;patchdir=${WORKDIR}/git/vendor/turris \
              file://map-implementation.patch;patchdir=${WORKDIR}/git/vendor/turris \
              file://0001-Add-hostapd-config.patch;patchdir=${WORKDIR}/git/vendor/turris \
              "
