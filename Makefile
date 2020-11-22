.SILENT:

all: help

help: ## show targets
	@cat $(MAKEFILE_LIST) \
		| grep -i "^[a-z0-9_-]*: .*## .*" \
		| awk 'BEGIN {FS = ":.*?## "} \
		  {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## build redpanda docker image
	./docker-builder.sh

run: ## run redpanda docker image [91m(no persistence !)[0m
	docker run \
		--rm \
		-p 19092:9092 \
		-p 19644:9644 \
		-i redpanda
