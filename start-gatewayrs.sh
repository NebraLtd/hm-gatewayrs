#!/bin/bash
# this scripts expects that the following environment variables are set
# I2C_DEVICE : the I2C device to use for ecc probe
# REGION_OVERRIDE/GW_REGION : without one of these two variables the region will default to US915
# for an asserted device it should not matter.
# Any other varialbe overrriding gateway rs setting file. gateway-rs allows us to 
# override all settings in the gateway-rs setting file. Refer readme at 
# https://github.com/helium/gateway-rs/tree/main for more details.

echo "Checking for I2C device"
I2C_NUM=$(echo "${I2C_DEVICE}" | cut -d "-" -f2)

# NOTE:: not sure we even need to do this. We should set the right environment or
# get it from hm-pyhelper and it should be correct. We are doing this only to make 
# sure that the gateway runs even when the I2C device is not present.
mapfile -t data < <( i2cdetect -y "${I2C_NUM}" )
for i in $(seq 1 ${#data[@]}); do
    # shellcheck disable=SC2206
    line=(${data[$i]})
    # shellcheck disable=SC2068
    if echo ${line[@]:1} | grep -q 60; then
        echo "ECC is present."
        ECC_CHIP=True
    fi
done

if [[ -v ECC_CHIP ]]
then
    echo "Using ECC for public key."
    export GW_KEYPAIR="ecc://i2c-${I2C_NUM}:96&slot=0"
elif [[ -v ALLOW_NON_ECC_KEY ]]
then
    echo "gateway-rs deb package provided key /etc/helium_gateway/gateway_key.bin will be used."
else
    echo "define ALLOW_NON_ECC_KEY environment variable to run gatewayrs without ecc."
    exit 1
fi

if [[ -v REGION_OVERRIDE ]]
then
  export GW_REGION="${REGION_OVERRIDE}"
fi

# NOTE: this should ultimately move to pktfwd container.
# the local rpc should is capable of providing this information
/opt/nebra-gatewayrs/gen-region.sh &

prevent_start="${PREVENT_START_GATEWAYRS:-0}"
if [ "$prevent_start" = 1 ]; then
    echo "gatewayrs will not be started. PREVENT_START_GATEWAYRS=1"
    while true; do sleep 1000; done
else
    # there is a systemd/sysv script for this service in the deb package
    # it doesn't make much sense to use it in the container
    /usr/bin/helium_gateway -c /etc/helium_gateway server
fi
