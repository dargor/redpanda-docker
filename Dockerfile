FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

# set this to the desired release
# you will also need to download the tgz,
# and possibly add packages if you change this
ARG REDPANDA_RELEASE=20.11.4

RUN apt -qy update \
 && apt -qy install \
                ninja-build \
                ragel \
                libhwloc-dev \
                libnuma-dev \
                libpciaccess-dev \
                libcrypto++-dev \
                libboost-all-dev \
                libxml2-dev \
                xfslibs-dev \
                libgnutls28-dev \
                liblz4-dev \
                libsctp-dev \
                gcc \
                make \
                libprotobuf-dev \
                protobuf-compiler \
                python3 \
                systemtap-sdt-dev \
                libtool \
                cmake \
                libyaml-cpp-dev \
                libc-ares-dev \
                stow \
                g++ \
                libfmt-dev \
                diffutils \
                valgrind \
                doxygen \
                curl \
                libzstd-dev \
                libsnappy-dev \
                libsystemd-dev \
                rapidjson-dev \
                libxxhash-dev \
                python3-venv \
                python3-jinja2 \
                pkg-config \
                git

WORKDIR /build
# if you are reading this because docker could not find this file,
# refer to the comment at the top of this file, before REDPANDA_RELEASE
ADD redpanda-release-${REDPANDA_RELEASE}.tar.gz .

WORKDIR /build/redpanda-release-${REDPANDA_RELEASE}
RUN cmake \
        -Wno-dev \
        -DCMAKE_BUILD_TYPE=Release \
        -B/build/redpanda-build-${REDPANDA_RELEASE} \
        -H/build/redpanda-release-${REDPANDA_RELEASE} \
        -GNinja \
        -DCMAKE_C_COMPILER=gcc \
        -DCMAKE_CXX_COMPILER=g++

WORKDIR /build/redpanda-build-${REDPANDA_RELEASE}
RUN ninja -j4 \
 && ln -s /tmp /dev/shm/vectorized_io \
 && ctest -j4 --progress --output-on-failure \
 && rm -rf /tmp/test.* /dev/shm/vectorized_io \
 && cmake --install .

WORKDIR /root
RUN rm -rf /build \
 && mkdir -p /var/lib/redpanda/data

EXPOSE 9092 9644
COPY redpanda.yaml /etc
CMD ["/usr/local/bin/redpanda", "--redpanda-cfg", "/etc/redpanda.yaml"]
