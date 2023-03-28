FROM quay.io/team-helium/miner:gateway-v1.0.0@sha256:f83f3002c59fd8539e3e1d985f824430d29de4a4ffd559ac394175de93479c42 as runner

# Move to working directory
RUN mkdir -p /opt/nebra-gatewayrs

WORKDIR /opt/nebra-gatewayrs

ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.0.0
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Copy start script and settings file
COPY *.sh ./
COPY nebra-gateway-settings-defaults.toml /etc/helium_gateway/settings.toml

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
