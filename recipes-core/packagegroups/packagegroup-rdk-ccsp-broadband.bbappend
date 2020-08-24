RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca-ccsp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "sys-resource"
#removing memstress for now following a build issue
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "memstress"
#removing mesh-agent for now. will be brought back along with opensync
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "mesh-agent"

RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "xupnp"

RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-hotspot-kmod"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = "\
    rdk-logger \
    libseshat \
    start-parodus \
"

#TODO: need to revisit if it breaks functionality. removing since it depends on ucresolv
#RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "parodus"

GWPROVAPP = "ccsp-gwprovapp-ethwan"

