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
            version = "1.0.4a";

            src = prev.fetchFromGitHub {
              owner = "Amulet-Team";
              repo = "Amulet-NBT";
              rev = "676e18c22abe398b524e2fd6da316b4e97936b8d";
              sha256 = "sha256-ogCjZmaJufRXD9rJLlsVQ7k/HRdMvK5Z4n/+BY/a6PQ=";
            };

            doCheck = false;

            nativeBuildInputs = [ pyPackages.cython ];

            buildInputs = with pyPackages; [
              numpy
            ];
          };

          pymctranslate = pyPackages.buildPythonPackage {
            pname = "pymctranslate";
            version = "1.0.12";

            src = prev.fetchFromGitHub {
              owner = "gentlegiantJGC";
              repo = "PyMCTranslate";
              rev = "bac6952dc2e3ea17690a49f04ee89279561c719e";
              sha256 = "sha256-jdYXuSDSYjqx4ZAtQtfn3JUvKUl5pL+F639BAFFITw4=";
            };

            doCheck = false;

            buildInputs = with prev.python37Packages; [
              numpy
              amulet-nbt
            ];
          };

          amulet-core = pyPackages.buildPythonPackage {
            pname = "amulet-core";
            version = "1.6.0a3";

            src = prev.fetchFromGitHub {
              owner = "Amulet-Team";
              repo = "Amulet-Core";
              rev = "93a71cc7be72a93bfd5bfed3e6944571a933ef66";
              sha256 = "sha256-h5Ge8xbhI+VqpKwMbkn0k6iQYn9+hUNbOqGn2Wqg1RU=";
            };

            nativeBuildInputs = [ pyPackages.cython ];

            buildInputs = with pyPackages; [
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
          packages = pkgs.amulet-core;
          defaultPackage = pkgs.amulet-core;
        }
      )
    );
}
