FROM quay.io/team-helium/miner:gateway-v1.0.0 AS runner

ENV PYTHON_DEPENDENCIES_DIR=/opt/python-dependencies

# grpcio has to be installed from cache
# hadolint ignore=DL3042,DL3018
RUN mkdir -p /opt/nebra-gatewayrs && \
    apk add --no-cache python3=3.10.11-r0 py3-grpcio==1.50.1-r0 gcompat && \
    python3 -m ensurepip && \
    pip3 install grpcio==1.50.1 && \
    pip3 install --no-cache-dir --target="$PYTHON_DEPENDENCIES_DIR" hm-pyhelper==0.14.4
WORKDIR /opt/nebra-gatewayrs

ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.0.0
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Copy start script and settings file
COPY *.sh ./
COPY nebra-gateway-settings-defaults.toml /etc/helium_gateway/settings.toml.template

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
