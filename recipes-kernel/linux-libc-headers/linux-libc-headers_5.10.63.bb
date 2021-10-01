require recipes-kernel/linux-libc-headers/linux-libc-headers.inc

SRC_URI[md5sum] = "ad5965c93acf124375dc54fcad8bab2a"
SRC_URI[sha256sum] = "19a15e838885a0081de5f9874e608fc3f3b1d9e69f2cc5cfa883b8b5499bcb2e"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI_remove += "file://0001-add-support-for-http-host-headers-cookie-url-netfilt.patch"
SRC_URI_append += "file://0001-add-support-for-http-host-headers-cookie-url-netfilt_4.14.patch"

do_install_armmultilib () {
	oe_multilib_header asm/auxvec.h asm/bitsperlong.h asm/byteorder.h asm/fcntl.h asm/hwcap.h asm/ioctls.h asm/kvm_para.h asm/mman.h asm/param.h asm/perf_regs.h asm/bpf_perf_event.h
	oe_multilib_header asm/posix_types.h asm/ptrace.h  asm/setup.h  asm/sigcontext.h asm/siginfo.h asm/signal.h asm/stat.h  asm/statfs.h asm/swab.h  asm/types.h asm/unistd.h
}

