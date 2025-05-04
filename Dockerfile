# syntax=docker/dockerfile:1

# --- Stage: Bullseye Builder ---
FROM --platform=linux/amd64 debian:bullseye AS builder-bullseye

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libssl-dev \
    ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone CivetWeb
RUN git clone https://github.com/civetweb/civetweb.git && \
    cd civetweb && \
    git checkout v1.16

WORKDIR /build/civetweb

# Configure and build (Bullseye specific - OpenSSL 1.1)
RUN rm -rf build && mkdir build && cd build && \
    cmake .. \
    -DCIVETWEB_ENABLE_CXX=ON \
    -DCIVETWEB_ENABLE_SSL=ON \
    -DCIVETWEB_SSL_OPENSSL_API_1_1=ON && \
    make

# --- Stage: Jammy Builder ---
FROM --platform=linux/amd64 ubuntu:jammy AS builder-jammy

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libssl-dev \
    ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone CivetWeb
RUN git clone https://github.com/civetweb/civetweb.git && \
    cd civetweb && \
    git checkout v1.16

WORKDIR /build/civetweb

# Configure and build (Jammy specific - OpenSSL 3.x)
RUN rm -rf build && mkdir build && cd build && \
    cmake .. \
    -DCIVETWEB_ENABLE_CXX=ON \
    -DCIVETWEB_ENABLE_SSL=ON && \
    make

# --- Stage: Noble Builder ---
FROM --platform=linux/amd64 ubuntu:noble AS builder-noble

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libssl-dev \
    ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone CivetWeb
RUN git clone https://github.com/civetweb/civetweb.git && \
    cd civetweb && \
    git checkout v1.16

WORKDIR /build/civetweb

# Configure and build (Noble specific - OpenSSL 3.x)
RUN rm -rf build && mkdir build && cd build && \
    cmake .. \
    -DCIVETWEB_ENABLE_CXX=ON \
    -DCIVETWEB_ENABLE_SSL=ON && \
    make

# --- Stage: Final Output ---
# Use a minimal image, 'scratch' is empty, suitable for just holding artifacts
FROM scratch AS final

# Copy binaries from each builder stage into the final image's /output directory
COPY --from=builder-bullseye /build/civetweb/build/src/civetweb ./civetweb-1.16-debian-bullseye-amd64
COPY --from=builder-jammy /build/civetweb/build/src/civetweb ./civetweb-1.16-ubuntu-jammy-amd64
COPY --from=builder-noble /build/civetweb/build/src/civetweb ./civetweb-1.16-ubuntu-noble-amd64
