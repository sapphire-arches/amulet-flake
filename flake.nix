{
  description = "Amulet editor core";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix, nixpkgs, flake-utils }:
    {
      overlay = final: prev:
        prev.lib.genAttrs [ "python39" "python310" ] (
          pyVersion: (prev.${pyVersion}.override (
            let
              py = prev.${pyVersion};
            in
            {
              packageOverrides = python-final: python-prev: rec {
                amulet-nbt = py.pkgs.callPackage ./nix/amulet-nbt { };
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
            amulet-nbt = pkgs.python39Packages.amulet-nbt;
            amulet-core = pkgs.python39Packages.amulet-core;
            pymctranslate = pkgs.python39Packages.pymctranslate;
          };
          defaultPackage = pkgs.python39Packages.amulet-core;
        }
      )
    );
}
