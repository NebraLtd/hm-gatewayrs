FROM balenalib/raspberry-pi-debian:buster-build as build

RUN apk add --no-cache \
rust=1.44.0-r0 \
curl=7.69.1-r3 \
cargo=1.44.0-r0 \
git=2.26.3-r0

RUN \
apt-get update && \
DEBIAN_FRONTEND="noninteractive" \
TZ="Europe/London" \
apt-get -y install \
curl \
rust \
cargo \
git \
--no-install-recommends && \
apt-get autoremove -y &&\
apt-get clean && \
rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/ryanteck/gateway-rs.git

WORKDIR /opt/gateway-rs

RUN cargo install cross && cargo install cargo-make
RUN cross build --release --target raspi01

RUN ls target/
