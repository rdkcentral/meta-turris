KBRANCH ?= "v5.10/standard/base"

require recipes-kernel/linux/linux-yocto.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.10:${THISDIR}/files:"

SRCREV_machine = "e07f317d5a289f06b7eb9025d2ada744cf22c940"
SRCREV_meta = "a19886b00ea7d874fdd60d8e3435894bb16e6434"

SRC_URI = "git://git.yoctoproject.org/linux-yocto.git;name=machine;branch=${KBRANCH}; \
           git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-5.10;destsuffix=${KMETA}"

SRC_URI += " file://defconfig \
             file://001-v5.11-arm64-dts-mcbin-singleshot-add-heartbeat-LED.patch \
             file://002-v5.11-ARM-dts-turris-omnia-enable-HW-buffer-management.patch \
             file://003-v5.11-ARM-dts-turris-omnia-add-comphy-handle-to-eth2.patch \
             file://004-v5.11-ARM-dts-turris-omnia-describe-switch-interrupt.patch \
             file://005-v5.11-ARM-dts-turris-omnia-add-SFP-node.patch \
             file://006-v5.11-ARM-dts-turris-omnia-add-LED-controller-node.patch \
             file://007-v5.11-ARM-dts-turris-omnia-update-ethernet-phy-node-and-handle-name.patch \
             file://008-v5.12-ARM-dts-turris-omnia-fix-hardware-buffer-management.patch \
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
             file://313-helios4-dts-status-led-alias.patch \
             file://314-arm64-dts-uDPU-switch-PHY-operation-mode-to-2500base.patch \
             file://315-armada-xp-linksys-mamba-resize-kernel.patch \
             file://316-armada-370-dts-fix-crypto-engine.patch \
             file://700-mvneta-tx-queue-workaround.patch \
             file://701-v5.14-net-ethernet-marvell-mvnetaMQPrio.patch \
             file://702-net-next-ethernet-marvell-mvnetaMQPrioOffload.patch \
             file://703-net-next-ethernet-marvell-mvnetaMQPrioFlag.patch \
             file://704-net-next-ethernet-marvell-mvnetaMQPrioQueue.patch \
             file://705-net-next-ethernet-marvell-mvnetaMQPrioTCOffload.patch \
             file://800-cpuidle-mvebu-indicate-failure-to-enter-deeper-sleep.patch \
             file://801-pci-mvebu-time-out-reset-on-link-up.patch \
             file://901-dt-bindings-Add-IEI-vendor-prefix-and-IEI-WT61P803-P.patch \
             file://902-drivers-mfd-Add-a-driver-for-IEI-WT61P803-PUZZLE-MCU.patch \
             file://903-drivers-hwmon-Add-the-IEI-WT61P803-PUZZLE-HWMON-driv.patch \
             file://904-drivers-leds-Add-the-IEI-WT61P803-PUZZLE-LED-driver.patch \
             file://905-Documentation-ABI-Add-iei-wt61p803-puzzle-driver-sys.patch \
             file://906-Documentation-hwmon-Add-iei-wt61p803-puzzle-hwmon-dr.patch \
             file://907-MAINTAINERS-Add-an-entry-for-the-IEI-WT61P803-PUZZLE.patch \
             file://910-drivers-leds-wt61p803-puzzle-improvements.patch \
" 

SRC_URI_remove += "file://0001-add-support-for-http-host-headers-cookie-url-netfilt.patch \
                   file://0001-selinux-update-netlink-socket-classes.patch \
                   file://nfsdisable.cfg \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
LINUX_VERSION ?= "5.10.63"

COMPATIBLE_MACHINE = "turris"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "kernel-meta"
KCONF_BSP_AUDIT_LEVEL = "2"

do_install_append() {
    install -d ${D}${includedir}
    install -m 0644 ${B}/include/generated/autoconf.h ${D}${includedir}/autoconf.h
}

sysroot_stage_all_append () {
    install -d ${SYSROOT_DESTDIR}${includedir}
    install -m 0644 ${D}${includedir}/autoconf.h ${SYSROOT_DESTDIR}${includedir}/autoconf.h
}

PACKAGES += "kernel-autoconf"
PROVIDES += "kernel-autoconf"

FILES_kernel-autoconf = "${includedir}/autoconf.h"
