DOCKER_REGISTRY ?= localhost:5000
DOCKER_USERNAME ?= jeremyhahn
IMAGE 			?= cropdroid-builder-standalone

default: build

build:
	docker build -t $(IMAGE) .

buildx:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		-f Dockerfile-standalone \
		-t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE)-ubuntu .

alpine:
	docker build -t $(IMAGE)-alpine . -f Dockerfile-alpine
