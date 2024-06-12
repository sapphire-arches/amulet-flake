{
  description = "Amulet editor core";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix, nixpkgs, flake-utils }:
    {
      overlays.default = final: prev:
        prev.lib.genAttrs [ "python310" "python311" "python312" ] (
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
                amulet-leveldb = py.pkgs.callPackage ./nix/amulet-leveldb {
                  # versioneer = versioneer_518;
                };
                pymctranslate = py.pkgs.callPackage ./nix/pymctranslate {
                  inherit amulet-nbt;
                };
                amulet-core = py.pkgs.callPackage ./nix/amulet-core {
                  inherit amulet-nbt amulet-leveldb pymctranslate versioneer_518;
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
              self.overlays.default
            ];
          };
        in
        {
          devShells.default = pkgs.mkShell {
            name = "amulet-flake-shell";

            buildInputs = [
              (pkgs.python310.withPackages (pypkgs: with pypkgs; [
                amulet-core
              ]))
            ];
          };
          packages = rec {
            amulet-nbt = pkgs.python312Packages.amulet-nbt;
            amulet-leveldb = pkgs.python312Packages.amulet-leveldb;
            amulet-core = pkgs.python312Packages.amulet-core;
            pymctranslate = pkgs.python312Packages.pymctranslate;
            versioneer_518 = pkgs.python312Packages.versioneer_518;
            default = amulet-core;
          };
        }
      )
    );
}
