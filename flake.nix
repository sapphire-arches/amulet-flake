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
                amulet-leveldb = py.pkgs.callPackage ./nix/amulet-leveldb { };
                pymctranslate = py.pkgs.callPackage ./nix/pymctranslate {
                  inherit amulet-nbt;
                  };
                amulet-core = py.pkgs.callPackage ./nix/amulet-core {
                  inherit amulet-nbt amulet-leveldb pymctranslate;
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
          devShell = pkgs.mkShell {
            name = "amulet-flake-shell";

            buildInputs = [
              (pkgs.python310.withPackages (pypkgs: with pypkgs; [
                amulet-core
              ]))
            ];
          };
          packages = {
            amulet-nbt = pkgs.python310Packages.amulet-nbt;
            amulet-leveldb = pkgs.python310Packages.amulet-leveldb;
            amulet-core = pkgs.python310Packages.amulet-core;
            pymctranslate = pkgs.python310Packages.pymctranslate;
            versioneer_518 = pkgs.python310Packages.versioneer_518;
          };
          defaultPackage = pkgs.python310Packages.amulet-core;
        }
      )
    );
}
