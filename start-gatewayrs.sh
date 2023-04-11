#!/bin/sh

# These scripts detect possible keypair and onboarding key locations
GW_KEYPAIR="$(./get_keypair.py)"
export GW_KEYPAIR

GW_ONBOARDING="$(./get_onboarding.py)"
export GW_ONBOARDING

# Set the packet forwarder listen address
GW_LISTEN="0.0.0.0:1680"
export GW_LISTEN

# Set the gRPC API listen address
GW_API="0.0.0.0:4467"
export GW_API

# Region param can be overridden with REGION_OVERRIDE environment parameter
# UNKNOWN is the default to detect impossible default value
if [ -n "${REGION_OVERRIDE+x}" ]; then
  export GW_REGION="${REGION_OVERRIDE}"
elif [ -f "/var/pktfwd/region" ]; then
  REGION_OVERRIDE="$(cat /var/pktfwd/region)"
  export GW_REGION="${REGION_OVERRIDE}"
fi

# This script runs in the background and checks the region every second.
# It would generate a region file if the gateway is not giving any error
# and returns a region other than the impossible default, UNKNOWN.
/opt/nebra-gatewayrs/gen-region.sh &

prevent_start="${PREVENT_START_GATEWAYRS:-0}"
if [ "$prevent_start" = 1 ]; then
    echo "gatewayrs will not be started. PREVENT_START_GATEWAYRS=1"
    while true; do sleep 1000; done
else
    echo "Starting gateway-rs..."
    helium_gateway server
fi
