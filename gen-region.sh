#!/usr/bin/env sh

# Wait until miner knows the regulatory region.
while ! helium_gateway info region > /dev/null 2>&1; do
    sleep 1
done

# Wait 30 seconds so gateway-rs has time to check region from config service
sleep 30

REGIONDATA=$(helium_gateway info region | grep "region" | cut -d ":" -f2 | tr -d " ,\"")

while [ "$REGIONDATA" = "UNKNOWN" ] || [ "$REGIONDATA" = "" ] || [ "$REGIONDATA" = "null" ]; do
    sleep 1
    REGIONDATA=$(helium_gateway info region | grep "region" | cut -d ":" -f2 | tr -d " ,\"")
done

if [ -f "/var/pktfwd/region" ]; then
  REGIONFILE=$(cat /var/pktfwd/region)
else
  REGIONFILE="None"
fi

if [ "$REGIONFILE" = "$REGIONDATA" ]; then
  echo "Region file data ($REGIONFILE) matches gateway-rs ($REGIONDATA)"
else
  echo "Region file data ($REGIONFILE) doesn't match gateway-rs ($REGIONDATA). Updating region file..."
  echo "$REGIONDATA" > /var/pktfwd/region
fi
