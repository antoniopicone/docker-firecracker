FROM golang:1.20.3-alpine3.17

RUN cd /tmp && \ 
    wget http://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.3-x86_64.tar.gz

COPY inittab /tmp/overlay/etc/inittab
COPY interfaces /tmp/overlay/etc/network/interfaces
COPY start-vm /tmp/overlay/start-mvm.sh
COPY resolv.conf  /tmp/overlay/etc/resolv.conf

COPY build-image /build-image
CMD ["/bin/bash", "/build-image"]
