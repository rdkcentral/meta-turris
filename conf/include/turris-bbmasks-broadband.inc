BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-hotspot-kmod.bb"
BBMASK .= "|meta-rdk/recipes-core/packagegroups/packagegroup-rdk-media-common.bb"
BBMASK .= "|meta-rdk-ext/recipes-support/base64/base64_git.bb"
BBMASK .= "|meta-browser/*"
BBMASK .= "|openembedded-core/meta/recipes-bsp/u-boot/libubootenv_0.2.bb"
BBMASK .= "|openembedded-core/meta/recipes-bsp/u-boot/libubootenv_0.3.1.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-webui-jst.bb"
BBMASK .= "|meta-rdk-ext/recipes-kernel/linux/linux-libc-headers_%.bbappend"

BBMASK .= "${@'' if os.path.isdir('|meta-openembedded/meta-oe/recipes-devtools/breakpad/breakpad_git.bb') else '|meta-cmf/recipes-devtools/breakpad/breakpad_git.bb'}"

