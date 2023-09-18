.DEFAULT_GOAL := build
IMAGE_NAME := test-aws-local-stack
STACK_NAME := test-aws-local-stack

build:
	docker build --no-cache -t $(IMAGE_NAME) -f Dockerfile .
	$(eval id := $(shell docker create $(IMAGE_NAME) echo))
	docker cp $(id):/lambda-layer.zip resources/
	docker rm -v $(id)

run:
	docker-compose -p $(STACK_NAME) up

clean:
	rm -rf resources/lambda-layer.zip
	docker-compose -p $(STACK_NAME) down --volumes
