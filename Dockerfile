FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

# set this to the desired release
# you will also need to download the tgz,
# and possibly add packages if you change this
ENV REDPANDA_RELEASE=v21.4.12

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

WORKDIR /root
EXPOSE 9092 9644 33145
VOLUME /var/lib/redpanda/data
