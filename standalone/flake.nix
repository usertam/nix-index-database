{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        metadata = pkgs.lib.importJSON ./metadata.json;
        index = metadata.platform.${system};
      in {
        packages.default = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "nix-index-db";
          version = metadata.version;
          src = let tag = builtins.substring 1 14 version;
          in builtins.fetchurl {
            url = "https://github.com/usertam/nix-index-db/raw/r${tag}/${index.store}";
            sha256 = index.hash;
          };
          phases = [ "installPhase" ];
          installPhase = ''
            install -Dm444 ${src} $out
          '';
        };
        defaultPackage = self.packages.${system}.default;
      });
}
