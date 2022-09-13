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
        index = metadata.platform.${system};
      in {
        default = pkgs.stdenvNoCC.mkDerivation rec {
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
    };
}
