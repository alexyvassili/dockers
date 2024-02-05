ifneq ("$(wildcard .env)","")
include .env
export
endif

ifndef CI_REGISTRY_ID
$(error CI_REGISTRY_ID is not set)
endif

CI_REGISTRY_SERVER ?= cr.yandex
CI_REGISTRY ?= $(CI_REGISTRY_SERVER)/$(CI_REGISTRY_ID)

BASE = "base"

DEBIAN_BASE = $(CI_REGISTRY)/debian:$(BASE)
AUTOPUBLISHER_BASE = $(CI_REGISTRY)/autopublisher:$(BASE)
PYTHON_311 = $(CI_REGISTRY)/python:3.11


all:
	@echo "Makefile commands:"
	@echo "    make all                        - Show this message"
	@echo "    make build-base                 - Build base Debian image"
	@echo "    make upload-base                - Build and upload base Debian image to the docker-registry"
	@echo "    make build-autopublisher-base   - Build base Autopublisher image"
	@echo "    make upload-autopublisher-base  - Build and upload base Autopublisher image to the docker-registry"
	@echo "    make build-python               - Build base Python image"
	@echo "    make upload-python              - Build and upload base Python image to the docker-registry"
	@echo "    make build-all                  - Build all images"
	@echo "    make upload-all                 - Build and upload all images to the docker-registry"
	@echo
	@exit 0


build-base:
	docker build -t $(DEBIAN_BASE) \
		--file debian-base/DebianBase.dockerfile \
		--target release .


upload-base: build-base
	docker push $(DEBIAN_BASE)


build-autopublisher-base:
	docker build -t $(AUTOPUBLISHER_BASE) \
		--build-arg DEBIAN=$(DEBIAN_BASE) \
		--file debian-base/AutopublisherBase.dockerfile \
		--target release .


upload-autopublisher-base: build-autopublisher-base
	docker push $(AUTOPUBLISHER_BASE)


build-python:
	docker build -t $(PYTHON_311) \
		--build-arg DEBIAN=$(DEBIAN_BASE) \
		--file python/Python3.11.dockerfile \
		--target release .


upload-python: build-python
	docker push $(PYTHON_311)


build-all: build-base build-autopublisher-base build-python


upload-all: upload-base upload-autopublisher-base upload-python
