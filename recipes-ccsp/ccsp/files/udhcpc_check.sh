#!bin/sh
#### Added workaround fix for getting erouter0 IP
sleep 30
EROUTER_IP=`ifconfig erouter0 | grep "inet addr" | xargs | cut -d ':' -f2 | cut -d ' ' -f1`
echo "erouter0 ip is $EROUTER_IP"
if [ "$EROUTER_IP" = "" ] ; then  
     udhcpc -i erouter0
fi
EROUTER_IP=`ifconfig erouter0 | grep "inet addr" | xargs | cut -d ':' -f2 | cut -d ' ' -f1`
sysevent set current_wan_ipaddr $EROUTER_IP

