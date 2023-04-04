#!/bin/sh

# The light gateway-rs expects a fixed ECC key address. We're providing it via an ENV variable
# which is supplied by helium-miner-software, hence hm-pyhelper.
awk -v SWARM_KEY_URI="$SWARM_KEY_URI" '{ sub(/SWARM_KEY_URI_PARAM/, SWARM_KEY_URI); print; }' /etc/helium_gateway/settings.toml.template > /etc/helium_gateway/settings.toml

if [ -n "${REGION_OVERRIDE+x}" ]; then
  export GW_REGION="${REGION_OVERRIDE}"
fi

# This script runs in the background and checks the region every second.
# It would generate a region file if the gateway is not giving any error
# and returns a region other than the impossible default, EU433.
/opt/nebra-gatewayrs/gen-region.sh &

prevent_start="${PREVENT_START_GATEWAYRS:-0}"
if [ "$prevent_start" = 1 ]; then
    echo "gatewayrs will not be started. PREVENT_START_GATEWAYRS=1"
    while true; do sleep 1000; done
else
    echo "Starting gateway-rs..."
    helium_gateway server
fi
