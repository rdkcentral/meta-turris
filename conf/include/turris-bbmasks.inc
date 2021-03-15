BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-webui-jst.bb"

#To avoid build time errors
BBMASK .= "|meta-rdk-ext/recipes-support/base64/base64_git.bb"
BBMASK .= "|meta-rdk-ext/recipes-kernel/linux/linux-libc-headers_%.bbappend"
