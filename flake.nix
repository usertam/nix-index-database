{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        metadata = pkgs.lib.importJSON ./metadata.json;
      in {
        packages.default = pkgs.stdenvNoCC.mkDerivation rec {
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
}
