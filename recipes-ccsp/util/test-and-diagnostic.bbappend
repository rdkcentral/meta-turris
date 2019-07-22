require recipes-ccsp/ccsp/ccsp_common_turris.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://diag-turris.patch \
" 
do_install_append () {
    # Test and Diagonastics XML 
       install -m 644 ${S}/config/TestAndDiagnostic_arm.XML ${D}/usr/ccsp/tad/TestAndDiagnostic.XML
}
