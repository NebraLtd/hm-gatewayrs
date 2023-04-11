#!/usr/bin/env sh

# Wait until miner knows the regulatory region.
while ! helium_gateway info region > /dev/null 2>&1; do
    sleep 1
done

REGIONDATA=$(helium_gateway info region | grep "region" | cut -d ":" -f2 | tr -d " ,\"")

while [ "$REGIONDATA" = "UNKNOWN" ] || [ "$REGIONDATA" = "" ]; do
    sleep 1
    REGIONDATA=$(helium_gateway info region | grep "region" | cut -d ":" -f2 | tr -d " ,\"")
done

echo "$REGIONDATA" > /var/pktfwd/region
