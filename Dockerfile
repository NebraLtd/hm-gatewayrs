FROM arm32v5/debian:buster-slim


RUN \
apt-get update && \
DEBIAN_FRONTEND="noninteractive" \
TZ="Europe/London" \
apt-get -y install \
wget \
ca-certificates \
--no-install-recommends && \
apt-get autoremove -y &&\
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/helium/gateway-rs/releases/download/v1.0.0-alpha.8/helium-gateway-v1.0.0-alpha.8-raspi01.deb
RUN dpkg -i helium-gateway-v1.0.0-alpha.8-raspi01.deb
