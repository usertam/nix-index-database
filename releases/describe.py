#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

# Usage: releases/describe.py <version> <nixpkgs-branch> <nixpkgs-commit>
# Write metadata of the given version to metadata.json.

import json
import sys

meta = {
    "version": sys.argv[1],
    "source": {
        "channel": sys.argv[2],
        "revision": sys.argv[3]
    }
}

with open('metadata.json', 'w') as f:
    json.dump(meta, f, indent=4)
    f.write('\n')
