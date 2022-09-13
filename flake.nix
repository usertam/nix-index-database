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
        metadata = pkgs.lib.importJSON ./metadata.json;
      in {
        default = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "nix-index-db";
          version = metadata.version;
          src = self;
          phases = [ "installPhase" ];
          installPhase = ''
            install -Dm444 -t $out ${src}/indices/index-*
          '';
        };
        defaultPackage = self.packages.${system}.default;
      });
    };
}
