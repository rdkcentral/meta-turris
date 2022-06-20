
DISTRO_FEATURES_append = " rdk-oss-ssa"
DISTRO_FEATURES_remove_dunfell = "telemetry2_0"

# RDKBDEV-73 : Dynamic DNS : Standardization based on broadband-forum.
DISTRO_FEATURES_append = " ddns_broadband"

# RDKBDEV-83 : Device Gateway Association using Managed Device
DISTRO_FEATURES_append = " device_gateway_association"

# RDKBDEV-50: Adding DSLite Functionality and related TR-181 DataModel Parameters
DISTRO_FEATURES_append = " dslite"

# REFPLTV-1137: DLNA support for xupnp
DISTRO_FEATURES_append = " dlna"

DISTRO_FEATURES_append = " meshwifi"
DISTRO_FEATURES_append = " ipv6"
DISTRO_FEATURES_append = " rdkb_wan_manager"

# RDKB-40900: RDKB support extender/nonrouter profile
DISTRO_FEATURES_append = " rdkb_extender"
