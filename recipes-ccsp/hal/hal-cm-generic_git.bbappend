do_configure_prepend(){
        if ! cat ${S}/cm_hal.c | grep -w  "INT cm_hal_snmpv3_kickstart_initialize(snmpv3_kickstart_table_t \*pKickstart_Table)" ; then
                echo "INT cm_hal_snmpv3_kickstart_initialize(snmpv3_kickstart_table_t *pKickstart_Table) { return RETURN_OK; }" >> ${S}/cm_hal.c
        fi
}
