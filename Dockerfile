FROM balenalib/raspberry-pi-debian:buster-run

WORKDIR /opt/nebra-gatewayrs

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
RUN dpkg -i helium-gateway-v1.0.0-alpha.9-raspi01.deb

COPY start-gatewayrs.sh .
RUN chmod +x /opt/nebra-gatewayrs/start-gatewayrs.sh

COPY settings.toml /etc/helium_gateway/settings.toml

ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]

#ENTRYPOINT ["/bin/bash"]

#CMD /opt/nebra-gatewayrs/start-gatewayrs.sh
