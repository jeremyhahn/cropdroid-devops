BUILD_HOME      ?= extra/devops/docker/base
DOCKER_REGISTRY ?= localhost:5000
DOCKER_USERNAME ?= jeremyhahn
IMAGE 			:= cropdroid-builder-base

#ifeq ($(shell basename `pwd`),base)
#	BUILD_HOME ?= .
#else
	
#endif

default: ubuntu

ubuntu:
	docker build -t $(IMAGE)-ubuntu . -f $(BUILD_HOME)/Dockerfile-ubuntu

buildx-ubuntu:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		-f $(BUILD_HOME)/Dockerfile-ubuntu \
		-t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE)-ubuntu .

alpine:
	docker build -t $(IMAGE)-alpine . -f $(BUILD_HOME)/Dockerfile-alpine

buildx-ubuntu:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		-f $(BUILD_HOME)/Dockerfile-alpine \
		-t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE)-alpine .
