FROM quay.io/team-helium/miner:gateway-v1.0.0 AS runner

WORKDIR /opt/nebra-gatewayrs
COPY requirements.txt requirements.txt

# grpcio has to be installed from cache
# hadolint ignore=DL3042,DL3018
RUN apk add --no-cache python3=3.10.11-r0 py3-grpcio==1.50.1-r0 gcompat && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    cp /etc/helium_gateway/settings.toml /etc/helium_gateway/settings.toml.orig

ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.0.0
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Copy start script and settings file
COPY *.sh ./
COPY *.py ./

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
