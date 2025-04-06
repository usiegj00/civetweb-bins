FROM --platform=linux/amd64 debian:bullseye


RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev

WORKDIR /build

RUN git clone https://github.com/civetweb/civetweb.git && \
    cd civetweb && \
    git checkout v1.16

WORKDIR /build/civetweb

# Configure for standard build
RUN rm -rf build && mkdir build && cd build && \
    cmake .. \
    -DCIVETWEB_ENABLE_CXX=ON \
    -DCIVETWEB_ENABLE_SSL=ON \
    -DCIVETWEB_SSL_OPENSSL_API_1_1=ON

# Build
RUN cd build && make

# The binary will be in /build/civetweb/build/src/civetweb
