RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca-ccsp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "sys-resource"
#removing memstress for now following a build issue
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "memstress"

RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "xupnp"


RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-hotspot-kmod"


RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-eth-agent"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = "\
    rdk-logger \
    libseshat \
    \
"

#TODO: need to revisit if it breaks functionality. removing since it depends on ucresolv
#RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "parodus"

GWPROVAPP = "ccsp-gwprovapp"

