FROM arm32v6/alpine:3.12.4 as buildstep

RUN apk add --no-cache \
rust=1.44.0-r0 \
curl=7.69.1-r3 \
cargo=1.44.0-r0 \
git=2.26.3-r0

WORKDIR /opt

RUN git clone https://github.com/ryanteck/gateway-rs.git

WORKDIR /opt/gateway-rs

RUN cross build --release --target raspi01
