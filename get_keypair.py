#!/usr/bin/env python3

from hm_pyhelper.miner_param import get_ecc_location

keypair_uri = get_ecc_location()
print(f"{keypair_uri}")
