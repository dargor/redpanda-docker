# Redpanda in Docker

Try [Redpanda](https://github.com/vectorizedio/redpanda) in Docker.

## Build

```sh
make build
```

Beware: the build process is **very** resource intensive !

I tried very hard to enforce some reasonable limits, where "reasonable" is tailored for an 8 cores / 16GB laptop.

The main problem here is the inability to limit the first `cmake` workers, which are forced to the available number of cores by upstream, including in a runtime-fetched dependency ([Seastar](https://github.com/scylladb/seastar)) that can not be patched beforehand.

As these workers are in fact `cc1plus` instances, a program known for its frugality, spawning 8 of them is almost guaranteed to end with an OOM, unless you are doing nothing else with your computer.

`docker build` seems to happily ignore any cpu/memory restriction, leaving no choice but a two step build:
- build a base image with all required dependencies
- spawn a builder container (with constrained resources thanks to [LXCFS](https://github.com/lxc/lxcfs), if available) to do the heavy work itself, and commit the resulting container as our Redpanda image

Of course none of this should be necessary if upstream did not enforce `-j$(nproc)` without any override possibility (see `redpanda/cmake/oss.cmake.in` and `seastar/cooking_recipe.cmake` for details, search for `build_concurrency_factor`). Docker could also include LXCFS stuff to have reliable resource limits, it would be nice.

## Run

```sh
make run
```

Redpanda should be accessible from ports `19092` (kafka) and `19644` (admin).

This command will show Redpanda logs, use `^C` to quit.

Beware: data will **not** persisted !

## Usage

### Consumer

**TODO: kafka-console-consumer.sh**

### Producer

**TODO: kafka-console-producer.sh**
