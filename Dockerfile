FROM arm32v5/debian:buster-slim


RUN \
apt-get update && \
DEBIAN_FRONTEND="noninteractive" \
TZ="Europe/London" \
apt-get -y install \
curl \
git \
--no-install-recommends && \
apt-get autoremove -y &&\
apt-get clean && \
rm -rf /var/lib/apt/lists/*
