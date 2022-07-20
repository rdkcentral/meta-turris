COMPATIBLE_MACHINE_turris = "turris"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.4:"

SRC_URI_remove += "file://0001-add-support-for-http-host-headers-cookie-url-netfilt.patch"
SRC_URI_remove += "file://0001-selinux-update-netlink-socket-classes.patch"

SRC_URI += " file://defconfig \
             file://000-v5.5-arm64-dts-marvell-Add-support-for-Marvell-CN9130-SoC.patch \
             file://001-PCI-aardvark-Wait-for-endpoint-to-be-ready-before-tr.patch \
             file://001-v5.5-arm64-dts-marvell-Add-support-for-CP115.patch \
             file://002-v5.5-arm64-dts-marvell-Prepare-the-introduction-of-CP115.patch \
             file://003-net-mvneta-introduce-mvneta_update_stats-routine.patch \
             file://003-v5.5-arm64-dts-marvell-Add-support-for-AP807-AP807-quad.patch \
             file://004-net-mvneta-introduce-page-pool-API-for-sw-buffer-man.patch \
             file://004-v5.5-arm64-dts-marvell-Add-AP807-quad-cache-description.patch \
             file://005-net-mvneta-rely-on-build_skb-in-mvneta_rx_swbm-poll-.patch \
             file://005-v5.5-arm64-dts-marvell-Drop-PCIe-I-O-ranges-from-CP11x-fi.patch \
             file://006-net-mvneta-add-basic-XDP-support.patch \
             file://006-v5.5-arm64-dts-marvell-Externalize-PCIe-macros-from-CP11x.patch \
             file://007-gpio-mvebu-avoid_error_message_for_optional_IRQ.patch \
             file://007-net-mvneta-move-header-prefetch-in-mvneta_swbm_rx_fr.patch \
             file://007-v5.5-arm64-dts-marvell-Enumerate-the-first-AP806-syscon.patch \
             file://008-net-mvneta-make-tx-buffer-array-agnostic.patch \
             file://008-v5.5-arm64-dts-marvell-Prepare-the-introduction-of-AP807-.patch \
             file://009-net-mvneta-add-XDP_TX-support.patch \
             file://009-v5.5-arm64-dts-marvell-Move-clocks-to-AP806-specific-file.patch \
             file://010-net-mvneta-fix-build-skb-for-bm-capable-devices.patch \
             file://011-arm64-dts-uDPU-remove-i2c-fast-mode.patch \
             file://012-arm64-dts-uDPU-SFP-cages-support-3W-modules.patch \
             file://013-net-mvneta-rely-on-page_pool_recycle_direct-in-mvnet.patch \
             file://014-mvneta-driver-disallow-XDP-program-on-hardware-buffe.patch \
             file://015-net-mvneta-fix-XDP-support-if-sw-bm-is-used-as-fallb.patch \
             file://016-PCI-aardvark-Train-link-immediately-after-enabling-t.patch \
             file://017-PCI-aardvark-Improve-link-training.patch \
             file://018-PCI-aardvark-Issue-PERST-via-GPIO.patch \
             file://019-PCI-aardvark-Add-PHY-support.patch \
             file://020-arm64-dts-marvell-armada-37xx-Set-pcie_reset_pin-to-.patch \
             file://021-arm64-dts-marvell-armada-37xx-Move-PCIe-comphy-handl.patch \
             file://022-arm64-dts-marvell-armada-37xx-Move-PCIe-max-link-spe.patch \
             file://023-arm64-dts-add-uDPU-i2c-bus-recovery.patch \
             file://024-PCI-aardvark-Don-t-touch-PCIe-registers-if-no-card-c.patch \
             file://025-power-reset-add-driver-for-LinkStation-power-off.patch \
             file://026-PCI-aardvark-Fix-initialization-with-old-Marvell-s-A.patch \
             file://027-arm64-dts-marvell-espressobin-Add-ethernet-switch-al.patch \
             file://028-arm64-dts-mcbin-singleshot-add-heartbeat-LED.patch \
             file://029-ARM-dts-turris-omnia-enable-HW-buffer-management.patch \
             file://030-ARM-dts-turris-omnia-add-comphy-handle-to-eth2.patch \
             file://031-ARM-dts-turris-omnia-describe-switch-interrupt.patch \
             file://032-ARM-dts-turris-omnia-add-SFP-node.patch \
             file://033-ARM-dts-turris-omnia-update-ethernet-phy-node-and-handle-name.patch \
             file://034-ARM-dts-turris-omnia-fix-hardware-buffer-management.patch \
             file://300-mvebu-Mangle-bootloader-s-kernel-arguments.patch \
             file://301-mvebu-armada-38x-enable-libata-leds.patch \
             file://302-add_powertables.patch \
             file://303-linksys_hardcode_nand_ecc_settings.patch \
             file://304-revert_i2c_delay.patch \
             file://305-armada-385-rd-mtd-partitions.patch \
             file://306-ARM-mvebu-385-ap-Add-partitions.patch \
             file://307-armada-xp-linksys-mamba-broken-idle.patch \
             file://308-armada-xp-linksys-mamba-wan.patch \
             file://309-linksys-status-led.patch \
             file://310-linksys-use-eth0-as-cpu-port.patch \
             file://311-adjust-compatible-for-linksys.patch \
             file://312-ARM-dts-armada388-clearfog-emmc-on-clearfog-base.patch \
             file://312-helios4-dts-status-led-alias.patch \
             file://314-arm64-dts-marvell-armada37xx-Add-eth0-alias.patch \
             file://315-arm64-dts-marvell-armada-3720-espressobin-add-ports-.patch \
             file://316-arm64-dts-uDPU-switch-PHY-operation-mode-to-2500base.patch \
             file://318-armada-xp-linksys-mamba-resize-kernel.patch \
             file://320-armada-370-dts-fix-crypto-engine.patch \
             file://400-find_active_root.patch \
             file://700-mvneta-tx-queue-workaround.patch \
             file://800-cpuidle-mvebu-indicate-failure-to-enter-deeper-sleep.patch \
             file://801-pci-mvebu-time-out-reset-on-link-up.patch \
             "

PACKAGES += "kernel-autoconf"
PROVIDES += "kernel-autoconf"

do_install_append() {
    install -d ${D}${includedir}
    install -m 0644 ${B}/include/generated/autoconf.h ${D}${includedir}/autoconf.h
}

sysroot_stage_all_append () {
    install -d ${SYSROOT_DESTDIR}${includedir}
    install -m 0644 ${D}${includedir}/autoconf.h ${SYSROOT_DESTDIR}${includedir}/autoconf.h
}


FILES_kernel-autoconf = "${includedir}/autoconf.h"
