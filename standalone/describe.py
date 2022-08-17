#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

# Usage: standalone/describe.py <version> <nixpkgs-branch> <nixpkgs-commit>
# Write metadata of the given version to metadata.json.

import json
import os
import subprocess
import sys

meta = {
    "version": sys.argv[1],
    "source": {
        "channel": sys.argv[2],
        "revision": sys.argv[3]
    },
    "platform": {}
}

for index in next(os.walk('indices'))[2]:
    path = "indices/{}".format(index)
    meta['platform'][index[6:]] = {
        "store": path,
        "hash": subprocess.run(['nix', 'hash', 'file', path], capture_output=True, text=True).stdout.strip()
    }

with open('metadata.json', 'w') as f:
    json.dump(meta, f, indent=4)
    f.write('\n')
