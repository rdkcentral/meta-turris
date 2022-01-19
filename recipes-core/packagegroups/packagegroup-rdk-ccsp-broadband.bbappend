RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca-ccsp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "sys-resource"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-cm-agent-ccsp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-cm-agent"

#removing memstress for now following a build issue
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "memstress"

#removing mesh-agent for now. will be brought back along with opensync
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "mesh-agent"

RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "xupnp"

#removing wanmanager components for now following runtime issues
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "rdktelcovoicemanager"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "rdk-vlanmanager"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "rdk-ppp-manager"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "rdk-fwupgrade-manager"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = "\
    rdk-logger \
    libseshat \
    start-parodus \
"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove_dunfell = "start-parodus"

#TODO: need to revisit if it breaks functionality. removing since it depends on ucresolv
#RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "parodus"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' rdk-wanmanager ', '', d)} "

GWPROVAPP = ""

