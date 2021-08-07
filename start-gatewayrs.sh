#!/bin/bash

if ! LISTEN_ADDR=$(/bin/hostname -i)
then
  exit 1
else
  export GW_LISTEN_ADDR="${LISTEN_ADDR}:1680"
fi

if ! GW_REGION="${REGION_OVERRIDE}"
then
  exit 1
else
  export GW_REGION
fi

if [ -f "/var/data/gateway_key.bin" ]
then
  export GW_KEYPAIR="/var/data/gateway_key.bin"
  if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway key info)
  then
    exit 1
  else
    echo "$PUBLIC_KEYS" > /var/data/public_keys
  fi
else
  if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway key info)
  then
    exit 1
  else
  cp /etc/helium_gateway/gateway_key.bin /var/data/gateway_key.bin
  export GW_KEYPAIR="/var/data/gateway_key.bin"
  echo "$PUBLIC_KEYS" > /var/data/public_keys
fi

/usr/bin/helium_gateway -c /etc/helium_gateway server
