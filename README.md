# nix-index-database
Weekly updated [nix-index](https://github.com/usertam/nix-index) database.

To install, run:
```sh
PLATFORM="$(nix-instantiate --eval -E '(import <nixpkgs> {}).stdenv.hostPlatform.system')"
mkdir -p $HOME/.cache/nix-index
curl -Lo $HOME/.cache/nix-index/files \
    https://github.com/usertam/nix-index-database/releases/latest/download/index-${PLATFORM:1:-1}
```
