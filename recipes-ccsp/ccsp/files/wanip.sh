##Added workaround fix for getting erouter0 ip
loop=1
sleep 20
while [ $loop -eq 1 ];
do
temp=`ip addr show erouter0 |grep -i 'inet ' |awk '{print $2}' | cut -d '/' -f1`
if [ "$temp" == "" ]; then
killall udhcpc
udhcpc -i erouter0 &
fi
sleep 60
done
