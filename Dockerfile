
FROM balenalib/raspberry-pi-debian-python:bullseye-run-20221215 as runner

# Move to working directory
WORKDIR /opt/nebra-gatewayrs

ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.0.0-rc.3
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Pull in latest helium gatewayrs deb file and install
RUN \
    curl -L "https://github.com/helium/gateway-rs/releases/download/${GATEWAY_RS_RELEASE}/helium-gateway-${GATEWAY_RS_RELEASE}-raspi01.deb" -o helium-gateway.deb && \
    dpkg -i helium-gateway.deb && \
    rm -f helium-gateway.deb

# Copy start script and settings file
COPY *.sh ./
COPY nebra-gateway-settings-defaults.toml /etc/helium_gateway/settings.toml

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
