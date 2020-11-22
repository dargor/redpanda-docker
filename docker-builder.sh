#! /usr/bin/env bash
set -eu

if [ -x /usr/bin/lxcfs ]; then
    # if lxcfs is available, use it
    LXCFS_OPTS="

        -v /var/lib/lxcfs/cgroup:/sys/fs/cgroup:rw

        -v /var/lib/lxcfs/proc/cpuinfo:/proc/cpuinfo:rw
        -v /var/lib/lxcfs/proc/diskstats:/proc/diskstats:rw
        -v /var/lib/lxcfs/proc/loadavg:/proc/loadavg:rw
        -v /var/lib/lxcfs/proc/meminfo:/proc/meminfo:rw
        -v /var/lib/lxcfs/proc/stat:/proc/stat:rw
        -v /var/lib/lxcfs/proc/swaps:/proc/swaps:rw
        -v /var/lib/lxcfs/proc/uptime:/proc/uptime:rw

        -v /var/lib/lxcfs/sys/devices/system/cpu/online:/sys/devices/system/cpu/online:rw

    "
fi

# build base image, mostly to keep APT packages in cache
docker build -t redpanda-builder .

# ensure a previous builder is not running
set +e
docker rm -f redpanda-builder
set -e

# start a builder container, with constrained resources
docker run \
    --rm \
    -dit \
    ${LXCFS_OPTS:-} \
    --cpuset-cpus 0-3 \
    --memory 12g \
    --name redpanda-builder \
    redpanda-builder bash

# build process
docker cp redpanda-builder.sh redpanda-builder:/build
docker exec -it redpanda-builder /build/redpanda-builder.sh

# snapshot the container to an image
docker commit redpanda-builder redpanda

# kill builder
docker kill redpanda-builder
