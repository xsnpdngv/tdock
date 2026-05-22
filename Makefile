IMAGE_NAME ?= pandock
VERSION ?= latest

.PHONY: all build push clean-image

all: build

build:
	docker build -t $(IMAGE_NAME):$(VERSION) .

push:
	docker buildx create --use --name multi-arch-builder || true
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME):$(VERSION) --push .

clean-image:
	docker rmi $(IMAGE_NAME):$(VERSION)