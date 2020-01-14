SUMMARY = "Custom core image package group for marvell boards"

LICENSE = "MIT"

inherit packagegroup

DEPENDS = "libnl"

PACKAGES = " \
	  packagegroup-turris-core \
	"

RDEPENDS_packagegroup-turris-core = " \
   packagegroup-core-boot \
   devmem2 \
   lttng-tools \
   pptp-linux \
   rp-pppoe  \
   iputils \
   btrfs-tools \
   util-linux-readprofile \
   wireless-tools \
   trace-cmd \
   cryptsetup \
   coreutils \
   dosfstools \
   e2fsprogs \
   fftw \
   hostapd \
   wpa-supplicant \
   iproute2 \
   libpcap \
   nfs-utils \
   openssh \
   openssl \
   rpcbind \
   python-core \
   sg3-utils \
   squashfs-tools \
   valgrind \
   testfloat \
   iperf \
   dhcp-server \
   iptables \
   dnsmasq \
   dt \
    "
RDEPENDS_packagegroup-turris-core_remove = "dt"

#turris omnia uses dropbear, so removing openssh
RDEPENDS_packagegroup-turris-core_remove = "openssh"
