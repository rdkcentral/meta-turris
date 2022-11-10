
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " \
    file://001_proc_struct_change.patch \
    file://002_nf_hook_ops_struct_change_5_14.patch \
"
