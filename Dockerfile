FROM golang:1.20.3-alpine3.17 as builder

RUN apk --no-cache add curl git make build-base \
    && echo "Pulling firectl binary from Github." \
    && git clone https://github.com/firecracker-microvm/firectl \
    && cd firectl && make && chmod u+x firectl \
    && cp firectl /usr/bin/firectl \
    && apk del curl git make build-base --no-cache

FROM alpine:3.17.3

ENV container docker

RUN apk add curl qemu-system-x86_64 libvirt \ 
    && apk add libvirt-daemon dbus polkit \
    && apk add qemu-img bash iproute2 e2fsprogs 

RUN curl -LOJ https://github.com/firecracker-microvm/firecracker/releases/download/v1.3.1/firecracker-v1.3.1-x86_64.tgz \
    && tar -xzf firecracker-v1.3.1-x86_64.tgz && mv release-v1.3.1-x86_64/firecracker-v1.3.1-x86_64 /usr/local/bin/firecracker \
    && chmod u+x /usr/local/bin/firecracker

RUN curl -fsSL -o /tmp/micro-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin

COPY --from=builder /usr/bin/firectl /usr/local/bin/firectl
COPY start-fire /usr/local/bin/start-fire
RUN chmod u+x /usr/local/bin/start-fire

VOLUME /rootfs

ENTRYPOINT ["/usr/local/bin/start-fire"]
