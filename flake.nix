{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        metadata = nixpkgs.lib.importJSON ./metadata.json;
        index = metadata.platform.${system};
        index-bin = builtins.fetchurl {
          url = "https://github.com/usertam/nix-index-db/raw/r${metadata.version}/${index.store}";
          sha256 = index.hash;
        };
      in {
        default = pkgs.runCommandLocal "nix-index-db-s${metadata.version}" {} ''
          install -m444 ${index-bin} $out
        '';
        defaultPackage = self.packages.${system}.default;
      });

      apps = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = {
          type = "app";
          program = builtins.toString (pkgs.writeShellScript "install.sh" ''
            mkdir -p $HOME/.cache/nix-index
            install -m444 ${self.packages.${system}.default} $HOME/.cache/nix-index/files
          '');
        };
      });
    };
}
