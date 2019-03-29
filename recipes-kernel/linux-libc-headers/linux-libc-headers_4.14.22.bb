 
SUMMARY = "Sanitized set of kernel headers for the C library's use"
SECTION = "devel"
LICENSE = "GPLv2"

#########################################################################
####                        PLEASE READ 
#########################################################################
#
# You're probably looking here thinking you need to create some new copy
# of linux-libc-headers since you have your own custom kernel. To put 
# this simply, you DO NOT.
#
# Why? These headers are used to build the libc. If you customise the 
# headers you are customising the libc and the libc becomes machine
# specific. Most people do not add custom libc extensions to the kernel
# and have a machine specific libc.
#
# But you have some kernel headers you need for some driver? That is fine
# but get them from STAGING_KERNEL_DIR where the kernel installs itself.
# This will make the package using them machine specific but this is much
# better than having a machine specific C library. This does mean your
# recipe needs a
#    do_configure[depends] += "virtual/kernel:do_shared_workdir"
# but again, that is fine and makes total sense.
#
# There can also be a case where your kernel extremely old and you want
# an older libc ABI for that old kernel. The headers installed by this
# recipe should still be a standard mainline kernel, not your own custom 
# one.
#
# -- RP

LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

python __anonymous () {
    major = d.getVar("PV",True).split('.')[0]
    if major == "3":
        d.setVar("HEADER_FETCH_VER", "3.0")
    elif major == "4":
        d.setVar("HEADER_FETCH_VER", "4.x")
    else:
        d.setVar("HEADER_FETCH_VER", "2.6")
}

inherit kernel-arch

KORG_ARCHIVE_COMPRESSION ?= "xz"


SOC_SRC_URI = "git://git@github.com/MarvellEmbeddedProcessors/linux-marvell.git;protocol=https"
SRCBRANCH = "linux-4.14.22-armada-18.06"
SRC_URI = "${SOC_SRC_URI};branch=${SRCBRANCH}"

SRCREV = "1357b78ad32c3dfc4933f8613ae3755e7b314eb6"


SRC_URI_remove = "file://0001-add-support-for-http-host-headers-cookie-url-netfilt.patch"
SRC_URI_append = "\
    file://0001-add-support-for-http-host-headers-cookie-url-netfilt_4.14.patch \
   "

SRC_URI_append_libc-musl = "\
    file://0001-libc-compat.h-fix-some-issues-arising-from-in6.h.patch \
    file://0002-libc-compat.h-prevent-redefinition-of-struct-ethhdr.patch \
    file://0003-remove-inclusion-of-sysinfo.h-in-kernel.h.patch \
   "

#SRC_URI[md5sum] = "c1af0afbd3df35c1ccdc7a5118cd2d07"
#SRC_URI[sha256sum] = "3e9150065f193d3d94bcf46a1fe9f033c7ef7122ab71d75a7fb5a2f0c9a7e11a"

S = "${WORKDIR}/git"


EXTRA_OEMAKE = " HOSTCC="${BUILD_CC}" HOSTCPP="${BUILD_CPP}""

do_configure() {
	oe_runmake allnoconfig
}

do_compile () {
}

do_install() {
	oe_runmake headers_install INSTALL_HDR_PATH=${D}${exec_prefix}
	# Kernel should not be exporting this header
	rm -f ${D}${exec_prefix}/include/scsi/scsi.h

	# The ..install.cmd conflicts between various configure runs
	find ${D}${includedir} -name ..install.cmd | xargs rm -f
}

BBCLASSEXTEND = "nativesdk"

#DEPENDS = "cross-linkage"
RDEPENDS_${PN}-dev = ""
RRECOMMENDS_${PN}-dbg = "${PN}-dev (= ${EXTENDPKGV})"

INHIBIT_DEFAULT_DEPS = "1"
DEPENDS += "unifdef-native"

