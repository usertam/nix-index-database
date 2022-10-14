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
      in {
        default = pkgs.runCommandLocal "nix-index-db-r${metadata.version}" {} ''
          cp -r ${self}/indices $out
        '';
        defaultPackage = self.packages.${system}.default;
      });
    };
}
