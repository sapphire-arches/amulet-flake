{
  description = "Amulet editor core";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix, nixpkgs, flake-utils }:
    {
      overlay = final: prev:
        let
          # Use Python 3.7 explicitly as that's what Amulet claims to want and
          # they use C extensions.
          pyPackages = prev.python37Packages;
        in
        rec {
          amulet-nbt = pyPackages.buildPythonPackage {
            pname = "amulet-nbt";
            version = "1.1.0a0";

            src = prev.fetchFromGitHub {
              owner = "Amulet-Team";
              repo = "Amulet-NBT";
              rev = "5ffa0ae797525101ed2012f03c72671a64dfb8c7";
              sha256 = "sha256-3DQ1DCNMgWRTWDuhn1+fOmUfAb23EART+YAH7mDrrs8=";
            };

            doCheck = false;

            nativeBuildInputs = [ pyPackages.cython ];

            propagatedBuildInputs = with pyPackages; [
              numpy
            ];

            patches = [
              ./fix-amulet-nbt-build.patch
            ];
          };

          pymctranslate = pyPackages.buildPythonPackage {
            pname = "pymctranslate";
            version = "1.1.0b1";

            src = prev.fetchFromGitHub {
              owner = "gentlegiantJGC";
              repo = "PyMCTranslate";
              rev = "3a08dfb9eede57f16e6da67bddd91ce3c74e2ab3";
              sha256 = "sha256-+uMZvjYl8zi87ID3bGNzrlVKFEIgUlhR1CRVVebvDKw=";
            };

            doCheck = false;

            propagatedBuildInputs = with prev.python37Packages; [
              numpy
              amulet-nbt
            ];
          };

          amulet-core = pyPackages.buildPythonPackage {
            pname = "amulet-core";
            version = "1.7.0a1";

            src = prev.fetchFromGitHub {
              owner = "Amulet-Team";
              repo = "Amulet-Core";
              rev = "fad173683012f95cc892afd16dc2a95ee7c4697f";
              sha256 = "sha256-6Tl7LPbqC45FmjZqJKVgpY6WKv6MWl0gzksRXN0jXs4=";
            };

            nativeBuildInputs = [ pyPackages.cython ];

            propagatedBuildInputs = with pyPackages; [
              numpy
              pymctranslate
              amulet-nbt
            ];

            doCheck = false;

            meta = with prev.lib; {
              description = "A Python 3 library to read and write data from Minecraft's various save formats.";
              homepage = "https://github.com/Amulet-Team/Amulet-Core";
            };
          };
        };

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
            amulet-nbt = pkgs.amulet-nbt;
            amulet-core = pkgs.amulet-core;
            pymctranslate = pkgs.pymctranslate;
          };
          defaultPackage = pkgs.amulet-core;
        }
      )
    );
}
