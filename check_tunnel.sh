#!/bin/bash

checkGoogle=`curl -I --interface utun --retry 5 -m 10 -o /dev/null -s -w %{http_code} https://www.google.com`;
echo 'checkGoogle ' $checkGoogle;
if [ "$checkGoogle"x = "200"x ]; then
    # tunnel working
        echo "Tunnel work well"

    if /usr/sbin/birdc show ospf neighbors | grep "There is no OSPF protocol running" -q; then
        echo "enable ospf"
        /usr/sbin/birdc enable ospf1
    fi

    if /usr/sbin/birdc6 show ospf neighbors | grep "There is no OSPF protocol running" -q; then
        echo "enable ospf-v3"
        /usr/sbin/birdc6 enable ospf1
    fi
else
    # tunnel down
        echo "Tunnel down"
    systemctl restart clash

    /usr/sbin/birdc disable ospf1
    /usr/sbin/birdc6 disable ospf1
fi