# nix-index-database
Weekly updated [nix-index](https://github.com/usertam/nix-index) database.
Built indices follow
[nixpkgs-unstable](https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixpkgs-unstable) branch; not
[master](https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/master).

To install, run:
```sh
PLATFORM="$(nix-instantiate --eval -E '(import <nixpkgs> {}).stdenv.hostPlatform.system' | tr -d \")"
mkdir -p $HOME/.cache/nix-index
curl -Lo $HOME/.cache/nix-index/files \
    https://github.com/usertam/nix-index-database/releases/latest/download/index-$PLATFORM
```
