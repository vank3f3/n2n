#!/bin/sh
/usr/local/sbin/edge -d n2n0 -r -a dhcp:0.0.0.0 -c foreign -k nopass -l foreign.v2s.n2n.zctmdc.cc:7963 -b;
sleep 10;
ping -c 1 -w 10 192.168.86.1 > /dev/null ;
return $?;