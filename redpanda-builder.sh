#! /usr/bin/env bash
set -eu

cd /build/redpanda-release-${REDPANDA_RELEASE}
cmake \
    -Wno-dev \
    -DCMAKE_BUILD_TYPE=Release \
    -B/build/redpanda-build-${REDPANDA_RELEASE} \
    -H/build/redpanda-release-${REDPANDA_RELEASE} \
    -GNinja \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++

cd /build/redpanda-build-${REDPANDA_RELEASE}
ninja

# put tests on disk, as they require a lot of space
ln -s /tmp /dev/shm/vectorized_io
ctest --progress --output-on-failure
rm -rf /tmp/test.* /dev/shm/vectorized_io

cmake --install .

cd /root
rm -rf /build
