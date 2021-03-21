FROM balenalib/raspberry-pi-debian:buster-build as build


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
