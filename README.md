# nix-index-db
Daily updated, multi-channel, multi-platform prebuilt [`nix-index`](https://github.com/usertam/nix-index) indices.

## Flavors
| Channels                | All platform indices        | Host platform only            |
| ----------------------- | --------------------------- | ----------------------------- |
| [`master`][2]           | `releases/master`           | `standalone/master`           |
| [`nixpkgs-unstable`][2] | `releases/nixpkgs-unstable` | `standalone/nixpkgs-unstable` |

## Oneshot Install
This installs the index to `~/.cache/nix-index/files`.
```sh
nix run github:usertam/nix-index-db/standalone/master
```

## Flakes Install
To install `nixpkgs-unstable` standalone using flakes in home-manager:
```nix
{
  inputs = {
    nix-index-db.url = "github:usertam/nix-index-db/standalone/nixpkgs-unstable";
    nix-index-db.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ({ pkgs, inputs, ... }: {
          home.file.".cache/nix-index/files" = {
            source = inputs.nix-index-db.packages.${pkgs.system}.default;
          };
        })
      ];
    };
  };
}
```

[1]: https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/master
[2]: https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixpkgs-unstable
