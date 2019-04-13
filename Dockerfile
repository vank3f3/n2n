FROM alpine

ENV type supernode
ENV listenport 10088
ENV devicename n2n0
ENV interfaceaddress dhcp:0.0.0.0
ENV communityname foreign
ENV Encryptionkey nopass
ENV supernodenet foreign.v2s.n2n.zctmdc.cc:7963 
ENV OPTIONS	""

RUN buildDeps=" \
                build-base \
                cmake \
                git \
                linux-headers \
                openssl-dev \
        "; \
        set -x \
        && apk update  \
        && apk upgrade \
        && apk add --no-cache \
        dhclient \
        openssl \
        $buildDeps \
        && mkdir -p /usr/src \
        && cd /usr/src \
        && git clone https://github.com/meyerd/n2n \
        && cd n2n/n2n_v2 \
        && cmake . \
        && make install \
        && cd / \
        && rm -fr /usr/src/n2n \
        && apk del $buildDeps \
        && rm -rf /var/cache/apk/*

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ADD run_tests.sh /tmp/run_tests.sh
RUN chmod +x /tmp/run_tests.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
