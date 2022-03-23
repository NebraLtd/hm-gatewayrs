#!/usr/bin/env sh

# Wait until miner knows the regulatory region.
while ! /usr/bin/helium_gateway info -k region > /dev/null 2>&1; do
    sleep 1
done

REGIONDATA=$(/usr/bin/helium_gateway info -k region | grep "region" | cut -d ":" -f2 | tr -d " ,\"")
echo "$REGIONDATA" > /var/pktfwd/region
