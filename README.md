# hm-gatewayrs: Helium gateway-rs container

This is containerized version of helium gateway-rs used by nebra hotspots.

We take the gateway-rs deb package created by Helium from their [Github repo](
https://github.com/helium/gateway-rs/releases) (built from the [GitHub source](https://github.com/helium/gateway-rs)

## Environment variables
`REGION_OVERRIDE` and `I2C_DEVICE` are used to load the correct settings for the gateway. All settings override will continue to work as documented by upstream [gateway-rs](https://github.com/helium/gateway-rs).

`PREVENT_START_GATEWAYRS` can be set to `1` to prevent the miner from starting.
This is helpful for debugging the miner manually.

## Mr Bump

[Mr Bump](https://github.com/mr-bump) is a GitHub bot we created to automate some tasks related to the miner software. This includes updating the miner to the latest GA (and tagging / releasing this update) as well as updating the necessary `docker-compose.yml` files.

Mr Bump is currently used in the following repos:
- [hm-miner](https://github.com/NebraLtd/hm-miner)
- [hm-pyhelper](https://github.com/NebraLtd/hm-pyhelper)
- [hm-gatewayrs](https://github.com/NebraLtd/hm-gatewayrs)
- [helium-miner-software](https://github.com/NebraLtd/helium-miner-software)
- [light-hotspot-software](https://github.com/NebraLtd/light-hotspot-software)
- [helium-5g-software](https://github.com/NebraLtd/helium-5g-software)

## Pre built containers

This repo automatically builds docker containers and uploads them to two repositories for easy access:
- [hm-gatewayrs on DockerHub](https://hub.docker.com/r/nebraltd/hm-gatewayrs)
- [hm-gatewayrs on GitHub Packages](https://github.com/NebraLtd/hm-gatewayrs/pkgs/container/hm-gatewayrs)

The images are tagged using the docker long and short commit SHAs for that release. The current version deployed to miners can be found in the [helium-miner-software repo](https://github.com/NebraLtd/helium-miner-software/blob/production/docker-compose.yml).
