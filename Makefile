REPOSITORY=$(shell git config --get remote.origin.url)
PRODUCT=$(shell echo $(REPOSITORY) | awk -F '[./]' '{print $$(NF-1)}')
IMAGE=$(shell echo $(PRODUCT) | awk '{print tolower($$0)}')
CONTAINER=$(IMAGE)
VNC_PORT=5900

.PHONY: test
test:
	./build.sh $(IMAGE) $(CONTAINER) $(VNC_PORT)

.PHONY: delete
delete:
	./delete.sh $(IMAGE) $(CONTAINER)

