#!/bin/sh

if [[ ${type} == "supernode" ]]; then
    /usr/local/sbin/supernode --help
    echo 
    echo 
    echo "/usr/local/sbin/supernode -l $listenport -f $OPTIONS"
    echo 
    echo 
    /usr/local/sbin/supernode -l $listenport -f $OPTIONS
elif [[ ${type} == "edge" ]]; then
    opr=""
    opb="-b"
    regex_ip="(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}"
    as_ip=`echo $supernodenet | grep -E "$regex_ip"`
    regex_dhcp="[dD][hH][cC][pP]"
    as_dhcp=`echo $interfaceaddress | grep -E "$regex_dhcp"`
    OPTIONS=`${OPTIONS//$opb/}`
    if [[ "$interfaceaddress" == "$as_dhcp"  ]]; then
        opr="-r"
        echo "判断输入网卡模式为DHCP"
        OPTIONS=`${OPTIONS//$opr/}`
    fi
    if [[ "$supernodenet" != "$as_ip" ]]; then 
        echo "判断输入supernode不是IP，自动添加参数 -b"
        OPTIONS="$opb $OPTIONS"
    fi
    #/usr/local/sbin/edge --help
    echo 
    echo 
    echo "/usr/local/sbin/edge -d $devicename $opr -a $interfaceaddress -c $communityname -k $Encryptionkey -l $supernodenet -f $OPTIONS"
    echo 
    echo 
    if [[ "$opr" == "-r" ]]; then
        for a in `seq 1`
        do
        {  
        waittime=5
            n2nip=""
            COUNTER=1
            while [[ "$n2nip" == "" && "$COUNTER" -lt 10 ]]; 
            do
            {
                echo "sleep ${waittime}"
                sleep ${waittime}
                echo
                echo
                echo "$devicename 未获取到IP"
                echo "即将自动获取IP地址"
                echo
                echo
                dhclient $devicename -r
                dhclient $devicename
                echo
                echo
                ifconfig $devicename 
                n2nip=`ifconfig $devicename | grep "inet addr:" | awk '{print $2}' | cut -c 6-`
                COUNTER=$(($COUNTER+1))
            }
	    done
            echo
	    if  [[ "$n2nip" == ""  ]]; then
	        echo "$devicename 无法获取到IP,请检查dhcpd服务端设置"
	    else
                echo "$devicename ip=${n2nip}"
            fi
	    echo
            echo
        }&
        done
    fi
    
    /usr/local/sbin/edge -d $devicename $opr -a $interfaceaddress -c $communityname -k $Encryptionkey -l $supernodenet -f $OPTIONS
else
    echo "type 没有设置"
fi
