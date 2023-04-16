all: basefs docker-firecracker

docker-firecracker:
	docker build -t antoniopicone/docker-firecracker:0.1.0 .
	docker tag antoniopicone/docker-firecracker:0.1.0 antoniopicone/docker-firecracker:latest

basefs:
	echo "Building go fs base"
	docker build -t antoniopicone/microvm-base-go:0.1.0 ./fs-base/go
	docker tag antoniopicone/microvm-base-go:0.1.0 antoniopicone/microvm-base-go:latest
