#!/bin/bash

if ! LISTEN_ADDR=$(/bin/hostname -i)
then
  echo "Can't get hostname"
  exit 1
else
  echo 'export GW_LISTEN_ADDR="${LISTEN_ADDR}:1680"' >> /etc/environment
fi

if [[ -v REGION_OVERRIDE ]]
then
  echo 'export GW_REGION="${REGION_OVERRIDE}"' >> /etc/environment
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

if [ -f "/var/data/gateway_key.bin" ]
then
  echo "Key file already exists"
  echo 'export GW_KEYPAIR="/var/data/gateway_key.bin"' >> /etc/environment
  if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway key info)
  then
    echo "Can't get miner key info"
    exit 1
  else
    echo "$PUBLIC_KEYS" > /var/data/public_keys
  fi
else
  if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway key info)
  then
    echo "Can't get miner key info"
    exit 1
  else
  echo "Copying key file to persistent storage"
  cp /etc/helium_gateway/gateway_key.bin /var/data/gateway_key.bin
  echo 'export GW_KEYPAIR="/var/data/gateway_key.bin"' >> /etc/environment
  echo "$PUBLIC_KEYS" > /var/data/public_keys
  fi
fi

source /etc/environment

/usr/bin/helium_gateway -c /etc/helium_gateway server
