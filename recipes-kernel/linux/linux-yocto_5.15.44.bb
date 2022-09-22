KBRANCH ?= "v5.15/standard/base"

require recipes-kernel/linux/linux-yocto.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto-5.15:${THISDIR}/files:"

SRCREV_machine = "eb3df10e3f3146911fc3235c458c8ef1660ae9df"
SRCREV_meta = "947149960e1426ace478e4b52c28a28ef8d6e74b"

SRC_URI = "git://git.yoctoproject.org/linux-yocto.git;name=machine;branch=${KBRANCH}; \
           git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-5.15;destsuffix=${KMETA}"


SRC_URI += " file://defconfig \
             file://300-mvebu-Mangle-bootloader-s-kernel-arguments.patch \
             file://301-mvebu-armada-38x-enable-libata-leds.patch \
             file://302-add_powertables.patch \
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
             file://400-find_active_root.patch \
             file://402-ath_regd_optional.patch \
             file://700-mvneta-tx-queue-workaround_5.15.patch \
	     file://701-net-ethernet-mtk_eth_soc-add-support-for-Wireless-Et-for-mt79.patch \
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
"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
LINUX_VERSION ?= "5.15.44"

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
