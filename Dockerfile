ARG GATEWAY_RS_RELEASE=v1.3.0

FROM quay.io/team-helium/miner:gateway-"$GATEWAY_RS_RELEASE" AS runner

ARG GATEWAY_RS_RELEASE
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Set the packet forwarder and gRPC API listen addresses.
# We set these here as they are static and more temperamental.
# Other overrides happen at runtime in start_gatewayrs.sh
ENV GW_API "0.0.0.0:4467"
ENV GW_LISTEN "0.0.0.0:1680"

WORKDIR /opt/nebra-gatewayrs
COPY requirements.txt requirements.txt

# grpcio has to be installed from cache
# hadolint ignore=DL3042,DL3018
RUN apk add --no-cache \
      python3=3.10.13-r0 \
      py3-grpcio=1.50.1-r0 \
      gcompat=1.1.0-r0 \
      i2c-tools=4.3-r1 && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy start script and settings file
COPY *.sh ./
COPY *.py ./

# Copy region check script to daily cron location
COPY gen-region.sh /etc/periodic/daily/gen-region

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
