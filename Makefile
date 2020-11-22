.SILENT:

all: help

help: ## show targets
	@cat $(MAKEFILE_LIST) \
		| grep -i "^[a-z0-9_-]*: .*## .*" \
		| awk 'BEGIN {FS = ":.*?## "} \
		  {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## build redpanda docker image
	docker build \
		--cpuset-cpus 0-3 \
		--memory 12g \
		-t redpanda \
		.

run: ## run redpanda docker image [91m(no persistence !)[0m
	docker run \
		--rm \
		--cpuset-cpus 0-3 \
		--memory 8g \
		-p 19092:9092 \
		-p 19644:9644 \
		-i redpanda
