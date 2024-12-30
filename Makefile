REPOSITORY=$(shell git config --get remote.origin.url)
PRODUCT=$(shell echo $(REPOSITORY) | awk -F '[./]' '{print $$(NF-1)}')
IMAGE=$(shell echo $(PRODUCT) | awk '{print tolower($$0)}')
CONTAINER=$(IMAGE)
VNC_PORT=5905
TARGET=wasabi.zip

.PHONY: build
build: $(TARGET)

.PHONY: delete
delete:
	./delete.sh $(IMAGE) $(CONTAINER)

.PHONY: run
run: build
	docker start $(CONTAINER)
	docker exec $(CONTAINER) /bin/bash -c "cd /root/wasabi && source /root/.cargo/env && make vnc > vnc.log 2>&1 &"
	docker exec $(CONTAINER) /bin/bash -c "cd /root/wasabi && source /root/.cargo/env && make run"
	docker stop $(CONTAINER)

$(TARGET):
	./build.sh $(IMAGE) $(CONTAINER) $(VNC_PORT)

