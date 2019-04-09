# n2n-vpn-docker

![alt tag](https://camo.githubusercontent.com/f35cee935830315c180ec86e8b0e551fbde2434b/68747470733a2f2f7765622e617263686976652e6f72672f7765622f3230313130393234303833303435696d5f2f687474703a2f2f7777772e6e746f702e6f72672f77702d636f6e74656e742f75706c6f6164732f323031312f30382f6e326e5f6e6574776f726b2e706e67)

![alt tag](https://camo.githubusercontent.com/e349c419b59d29e2d196ea3317f73582232cc65f/68747470733a2f2f7765622e617263686976652e6f72672f7765622f3230313130393234303833303435696d5f2f687474703a2f2f7777772e6e746f702e6f72672f77702d636f6e74656e742f75706c6f6164732f323031312f30382f6e326e5f636f6d2e706e67)

# BUID
     git clone https://github.com/zctmdc/n2n.git
     cd n2n
     docker build -t n2nv2s:latest .
     
     
# start supernode

     docker run --rm -ti --name 10088:10088/udp --name n2n_supernode -e tpye=supernode n2nv2s:latest
     
      docker run -d \
          --name n2n_supernode
          --restart=always \
          -p 10088:10088/udp \
          --name n2n_supernode \
          -e tpye=supernode \
          -e listenport=10088 \
          -e OPTIONS=""
          n2nv2s:latest

# start edge


     docker run --rm -ti --name n2n_edge_dhcp  --privileged -e type=edge  n2nv2s:latest 

## DHCP
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
          n2nv2s:latest
     
## STATIC
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
          n2nv2s:latest
### SELF TEST     
//node IP 10.9.9.1

     docker run -d --privileged --net=host --name n2n_edge -e type=edge -e interfaceaddress=10.9.9.1 -e supernodenet=192.168.3.108:61099 n2nv2s:latest 
    
//node IP 10.9.9.2

     docker run -d --privileged --net=host --name n2n_edge -e type=edge -e interfaceaddress=10.9.9.2 -e supernodenet=192.168.3.108:61099 n2nv2s:latest

### DHCP
     docker exec -ti n2n_edge_dhcp sh
     dhclient $devicename
     
