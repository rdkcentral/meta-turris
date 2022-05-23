FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# we need to patch to code for ovs-agent
do_turris_ovsagent_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch  -p1 < ${WORKDIR}/add-systemd-support.patch || echo "ERROR or Patch already applied"
        touch patch_applied
    fi
}
addtask turris_ovsagent_patches after do_unpack before do_configure

