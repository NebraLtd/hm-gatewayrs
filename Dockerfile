ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=1.0.0
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE
ARG BUILD_BOARD
ENV BUILD_BOARD $BUILD_BOARD

FROM alpine:3.17.3
ENV RUST_BACKTRACE=1
ENV GW_LISTEN="0.0.0.0:1680"

ADD https://github.com/helium/gateway-rs/releases/download/v"$GATEWAY_RS_RELEASE"/helium-gateway-"$GATEWAY_RS_RELEASE"-"$BUILD_BOARD".tar.gz /tmp/helium-gateway.tar.gz
RUN tar -xzf /tmp/helium-gateway.tar.gz && \
    mv /tmp/helium-gateway/helium_gateway /usr/local/bin/helium_gateway && \
    mkdir /etc/helium_gateway && \
    mv /tmp/helium-gateway/settings.toml /etc/helium_gateway/settings.toml && \
    rm -Rf /tmp/helium-gateway && \
    rm -f /tmp/helium-gateway.tar.gz

WORKDIR /opt/nebra-gatewayrs
COPY requirements.txt requirements.txt

# grpcio has to be installed from cache
# hadolint ignore=DL3042,DL3018
RUN apk add --no-cache python3=3.10.11-r0 py3-grpcio==1.50.1-r0 gcompat && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    cp /etc/helium_gateway/settings.toml /etc/helium_gateway/settings.toml.orig

# Copy start script and settings file
COPY *.sh ./
COPY *.py ./

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
