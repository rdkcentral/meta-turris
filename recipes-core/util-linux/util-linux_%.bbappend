do_install_append_broadband() {
 rm -rf ${D}${base_sbindir}/hwclock
 rm -rf ${D}${base_bindir}/more
 rm -rf ${D}${base_bindir}/kill
 rm -rf ${D}${base_bindir}/dmesg
 rm -rf ${D}${bindir}/chrt
 rm -rf ${D}${bindir}/eject
 rm -rf ${D}${bindir}/flock
 rm -rf ${D}${bindir}/hexdump
 rm -rf ${D}${bindir}/logger
 rm -rf ${D}${bindir}/mesg
 rm -rf ${D}${bindir}/renice
 rm -rf ${D}${bindir}/setsid
 rm -rf ${D}${sbindir}/blkdiscard
 rm -rf ${D}${sbindir}/blkzone
 rm -rf ${D}${base_sbindir}/blockdev
 rm-rf ${D}${base_sbindir}/cfdisk
 rm -rf ${D}${bindir}/cal
 rm -rf ${D}${bindir}/chmem
 rm -rf ${D}${bindir}/choom
 rm -rf ${D}${bindir}/colcrt
 rm -rf ${D}${bindir}/colrm
 rm -rf ${D}${bindir}/col
 rm -rf ${D}${bindir}/column
 rm -rf ${D}${bindir}/fallocate
 rm -rf ${D}${sbindir}/chcpu
 rm -rf ${D}${base_sbindir}/ctrlaltdel
 rm -rf ${D}${base_sbindir}/fstrim
 rm -rf ${D}${base_sbindir}/mkswap
 rm -rf ${D}${base_sbindir}nologin
 rm -rf ${D}${sbindir}/delpart
 rm -rf ${D}${sbindir}/fdformat
 rm -rf ${D}${sbindir}/findfs
 rm -rf ${D}${sbindir}/fsfreeze
 rm -rf ${D}${bindir}/fincore
 rm -rf ${D}${bindir}/hardlink
 rm -rf ${D}${bindir}/ionice
 rm -rf ${D}${bindir}/ipcmk
 rm -rf ${D}${bindir}/ipcrm
 rm -rf ${D}${bindir}/ipcs
 rm -rf ${D}${bindir}/isosize
 rm -rf ${D}${bindir}/look
 rm -rf ${D}${bindir}/lsblk
 rm -rf ${D}${bindir}/lscpu
 rm -rf ${D}${bindir}/lspic
 rm -rf ${D}${bindir}/namei
 rm -rf ${D}${bindir}/lslocks
 rm -rf ${D}${bindir}/lslogins
 rm -rf ${D}${bindir}/lsns
 rm -rf ${D}${bindir}/lsmem
 rm -rf ${D}${bindir}/nsenter
 rm -rf ${D}${bindir}/mcookie
 rm -rf ${D}${sbindir}/ldattach
 rm -rf ${D}${sbindir}/partx
 rm -rf ${D}${sbindir}/raw
 rm -rf ${D}${sbindir}/resizepart
 rm -rf ${D}${sbindir}/rtcwake
 rm -rf ${D}${bindir}/whereis
 rm -rf ${D}${bindir}/wdctl
 rm -rf ${D}${bindir}/write
 rm -rf ${D}${bindir}/prlimit
 rm -rf ${D}${bindir}/rev
 rm -rf ${D}${bindir}/rename
 rm -rf ${D}${bindir}/scriptlive
 rm -rf ${D}${bindir}/scriptreplay
 rm -rf ${D}${bindir}/script
 rm -rf ${D}${bindir}/setterm
 rm -rf ${D}${bindir}/taskset
 rm -rf ${D}${sbindir}/swaplabel
 rm -rf ${D}${sbindir}/wipefs
 rm -rf ${D}${sbindir}/zramctl
 rm -rf ${D}${bindir}/ul
 rm -rf ${D}${bindir}/utmpdump
 rm -rf ${D}${bindir}/uuidparse
 rm -rf ${D}${bindir}/wall
}
do_install_append_dunfell_broadband() {
 rm -rf ${D}${base_sbindir}/swapon
 rm -rf ${D}${base_sbindir}/swapoff
 rm -rf ${D}${base_sbindir}/losetup
}
  
 

