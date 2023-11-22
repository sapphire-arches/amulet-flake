{
  description = "Amulet editor core";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix, nixpkgs, flake-utils }:
    {
      overlay = final: prev:
        prev.lib.genAttrs [ "python310" "python311" ] (
          pyVersion: (prev.${pyVersion}.override (
            let
              py = prev.${pyVersion};
            in
            {
              packageOverrides = python-final: python-prev: rec {
                versioneer_518 = py.pkgs.callPackage ./nix/versioneer_518/default.nix { };
                amulet-nbt = py.pkgs.callPackage ./nix/amulet-nbt {
                  inherit versioneer_518;
                };
                pymctranslate = py.pkgs.callPackage ./nix/pymctranslate { inherit amulet-nbt; };
                amulet-core = py.pkgs.callPackage ./nix/amulet-core {
                  inherit amulet-nbt pymctranslate;
                  portalocker = python-prev.portalocker;
                };
              };
            }
          )
          )
        );
    } // (
      flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
            ];
          };
        in
        {
          packages = {
            amulet-nbt = pkgs.python310Packages.amulet-nbt;
            amulet-core = pkgs.python310Packages.amulet-core;
            pymctranslate = pkgs.python310Packages.pymctranslate;
            versioneer_518 = pkgs.python310Packages.versioneer_518;
          };
          defaultPackage = pkgs.python310Packages.amulet-core;
        }
      )
    );
}
