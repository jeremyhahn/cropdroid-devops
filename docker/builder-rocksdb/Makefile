DOCKER_REGISTRY ?= localhost:5000
DOCKER_USERNAME ?= jeremyhahn
IMAGE 			?= builder-rocksdb

default: ubuntu

all: buildx-alpine buildx-ubuntu

ubuntu:
	docker build -t $(IMAGE)-ubuntu . -f Dockerfile-ubuntu

buildx-ubuntu:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		-f Dockerfile-ubuntu \
		-t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE)-ubuntu .

alpine:
	docker build -t $(IMAGE)-alpine . -f $(BUILD_HOME)/Dockerfile-alpine

buildx-alpine:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		-f Dockerfile-alpine \
		-t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE)-alpine .
