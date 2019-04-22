SUMMARY = "common inc for turris"

CFLAGS_append += " -U_COSA_SIM_ -fno-exceptions -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-strict-aliasing \
           -D_ANSC_LINUX -D_ANSC_USER -D_ANSC_LITTLE_ENDIAN_ -D_CCSP_CWMP_TCP_CONNREQ_HANDLER \
           -D_DSLH_STUN_ -D_NO_PKI_KB5_SUPPORT -D_BBHM_SSE_FILE_IO -D_ANSC_USE_OPENSSL_ -DENABLE_SA_KEY \
           -D_ANSC_AES_USED_ -D_NO_EXECINFO_H_ -DFEATURE_SUPPORT_SYSLOG \
           -DBUILD_WEB -D_NO_ANSC_ZLIB_ -D_DEBUG -U_ANSC_IPV6_COMPATIBLE_ -DUSE_NOTIFY_COMPONENT \
           -D_PLATFORM_TURRIS_ -DENABLE_SD_NOTIFY -DCOSA_DML_WIFI_FEATURE_LoadPsmDefaults -UPARODUS_ENABLE"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"
