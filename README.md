# Redpanda in Docker

Try [Redpanda](https://github.com/vectorizedio/redpanda) in Docker.

## Build

```sh
make build
```

Beware: the build process is **very** resource intensive !

I tried to set some reasonable limits in the `Makefile`, where "reasonable" is tailored for an 8 cores / 16GB laptop.

The main problem here is the inability to limit the first `cmake` workers, which are forced to the available number of cores by upstream, including in a runtime-fetched dependency ([Seastar](https://github.com/scylladb/seastar)).

As these workers are in fact `cc1plus` instances, a program known for its frugality, spawning 8 of them is almost guaranteed to end with an OOM.

Maybe try [LXCFS](https://github.com/lxc/lxcfs) to force less cores in kernel-exposed files ? Something like `docker run --rm --cpuset-cpus 0-3 -v /var/lib/lxcfs/proc/cpuinfo:/proc/cpuinfo:rw ubuntu grep -c ^processor /proc/cpuinfo` seems to work, but I have not yet tried a build with `lxcfs`.

Update: `docker build` happily ignore any cpu/memory restriction, leaving no choice but a two step build:
  - build a base image with dependencies and a build script
  - spawn a live container to do the build itself
  - commit the resulting container as an image

Of course none of this should be necessary if upstream did not enforce `-j$(nproc)` without any override possibility (see `redpanda/cmake/oss.cmake.in` and `seastar/cooking_recipe.cmake` for details, search `build_concurrency_factor`).

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
