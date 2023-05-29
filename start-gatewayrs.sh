#!/bin/sh

# These scripts detect possible keypair and onboarding key locations
GW_KEYPAIR="$(./get_keypair.py)"
if [ "$GW_KEYPAIR" != "None" ]; then
  export GW_KEYPAIR
else
  echo "ERROR: Can't find ECC. Ensure SWARM_KEY_URI is correct in hardware definitions."
fi

GW_ONBOARDING="$(./get_onboarding.py)"
if [ "$GW_ONBOARDING" != "None" ]; then
  export GW_ONBOARDING
else
  echo "ERROR: Can't find onboarding key. Ensure ONBOARDING_KEY_URI is correct in hardware definitions."
fi

# When changing regulatory region for a particular area it might be necessary
# to forceably delete the region file from persistent storage to avoid issues.
if [ "$DELETE_REGION_FILE" = "True" ]; then
  rm -f /var/pktfwd/region
fi

# Region param can be overridden with REGION_OVERRIDE environment parameter
# UNKNOWN is the default to detect impossible default value
if [ -n "${REGION_OVERRIDE+x}" ]; then
  export GW_REGION="${REGION_OVERRIDE}"
elif [ -f "/var/pktfwd/region" ]; then
  REGION_OVERRIDE="$(cat /var/pktfwd/region)"
  export GW_REGION="${REGION_OVERRIDE}"
fi

# Wait for the diagnostics app to be loaded
until wget -q -T 10 -O - http://diagnostics:80/initFile.txt > /dev/null 2>&1
do
  echo "Diagnostics container not ready. Going to sleep."
  sleep 10
done

# This script runs in the background and checks the region every second.
# It would generate a region file if the gateway is not giving any error
# and returns a region other than the impossible default, UNKNOWN.
/opt/nebra-gatewayrs/gen-region.sh &

# Run crond in background to periodically check region.
crond -l 8

prevent_start="${PREVENT_START_GATEWAYRS:-0}"
if [ "$prevent_start" = 1 ]; then
    echo "gatewayrs will not be started. PREVENT_START_GATEWAYRS=1"
    while true; do sleep 1000; done
else
    echo "Starting gateway-rs..."
    helium_gateway server
fi
