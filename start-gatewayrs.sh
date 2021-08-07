#!/bin/bash

if ! LISTEN_ADDR=$(/bin/hostname -i)
then
  exit 1
else
  export GW_LISTEN_ADDR="${LISTEN_ADDR}:1680"
  export GW_REGION="${REGION_OVERRIDE}"
fi

/usr/bin/helium_gateway -c /etc/helium_gateway server
