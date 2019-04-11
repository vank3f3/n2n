# n2n-vpn-docker

![alt tag](https://camo.githubusercontent.com/f35cee935830315c180ec86e8b0e551fbde2434b/68747470733a2f2f7765622e617263686976652e6f72672f7765622f3230313130393234303833303435696d5f2f687474703a2f2f7777772e6e746f702e6f72672f77702d636f6e74656e742f75706c6f6164732f323031312f30382f6e326e5f6e6574776f726b2e706e67)

![alt tag](https://camo.githubusercontent.com/e349c419b59d29e2d196ea3317f73582232cc65f/68747470733a2f2f7765622e617263686976652e6f72672f7765622f3230313130393234303833303435696d5f2f687474703a2f2f7777772e6e746f702e6f72672f77702d636f6e74656e742f75706c6f6164732f323031312f30382f6e326e5f636f6d2e706e67)

# BUILD 编译
```
docker build -t zctmdc/n2nv2s https://github.com/zctmdc/docker_n2nv2s.git
```
# start supernode 打开为中心节点
> 如果你在windowsCMD上执行，请将\替换为^  

```
docker run --rm -ti -p 10088:10088/udp -e tpye=supernode zctmdc/n2nv2s
```
     
```
docker run -d \
	--name n2n_supernode
	--restart=always \
	-p 10088:10088/udp \
	--name n2n_supernode \
	-e tpye=supernode \
	-e listenport=10088 \
	-e OPTIONS=""
	zctmdc/n2nv2s
```

 

# start edge 打开为边缘节点
```
docker run --rm -ti --privileged --net=host -e type=edge  zctmdc/n2nv2s 
```

## STATIC 指定静态IP模式
```
docker run  -d \
	--name n2n_edge_static \
	--restart=always \
	--privileged \
	--net=host \
	-e type=edge \
	-e devicename=n2n0  \
	-e interfaceaddress=192.168.86.20 \
	-e communityname=foreign \
	-e Encryptionkey=nopass \
	-e supernodenet=foreign.v2s.n2n.zctmdc.cc:7963 \
	-e OPTIONS="-f -b -v" \
	zctmdc/n2nv2s
```          
## DHCP 动态自动获取IP模式 
>你得先打开一个静态模式的节点，并且打设置好DHCPD服务
```
docker run  -d \
	--restart=always \
	--name n2n_edge_dhcp \
	--privileged \
	--net=host \
	-e type=edge \
	-e devicename=n2n0  \
	-e interfaceaddress=dhcp:0.0.0.0 \
	-e communityname=foreign \
	-e Encryptionkey=nopass \
	-e supernodenet=foreign.v2s.n2n.zctmdc.cc:7963 \
	-e OPTIONS="-f -r -b" \
	zctmdc/n2nv2s
```     
## DEMO  演示
### node n2n_edge_01 IP 10.9.9.1
```
docker run -d --privileged --net=host --name n2n_edge_01 -e type=edge -e interfaceaddress=10.9.9.1 zctmdc/n2nv2s 
```
    
### node n2n_edge_01 IP 10.9.9.2
```
docker run -d --privileged --net=host --name n2n_edge_01 -e type=edge -e interfaceaddress=10.9.9.2 zctmdc/n2nv2s 
```  
### TEST    测试
```
docker exec -ti n2n_edge_01 sh -c "ping 10.9.9.2 -c 5"
docker exec -ti n2n_edge_02 sh -c "ping 10.9.9.1 -c 5"
```    
## DHCP 自动获取IP
```
docker exec -ti n2n_edge_dhcp sh
dhclient $devicename
```
## windows:
### 前台执行
```
docker exec n2n_edge_dhcp sh -c "dhclient $devicename -r && dhclient $devicename && ifconfig $devicename"
```
### 后台执行
```
start /b docker exec n2n_edge_dhcp sh -c "dhclient $devicename -r && dhclient $devicename"
 ```
## Linux:
### 前台执行
```
docker exec n2n_edge_dhcp sh -c "dhclient \$devicename -r && dhclient \$devicename && ifconfig \$devicename"
```
### 后台执行
```
docker exec n2n_edge_dhcp sh -c "dhclient \$devicename -r && dhclient \$devicename" &
```
# 项目地址：
[vank3f3/n2n](https://github.com/vank3f3/n2n)  
[meyerd/n2n](https://github.com/meyerd/n2n)  
