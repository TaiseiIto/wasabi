REPOSITORY=$(shell git config --get remote.origin.url)
PRODUCT=$(shell echo $(REPOSITORY) | awk -F '[./]' '{print $$(NF-1)}')
IMAGE=$(shell echo $(PRODUCT) | awk '{print tolower($$0)}')
CONTAINER=$(IMAGE)
VNC_PORT=5905

.PHONY: build
build:
	./build.sh $(IMAGE) $(CONTAINER) $(VNC_PORT)

.PHONY: delete
delete:
	./delete.sh $(IMAGE) $(CONTAINER)

.PHONY: run
run: build
	./run.sh $(CONTAINER)

