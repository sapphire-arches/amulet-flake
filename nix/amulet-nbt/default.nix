{ buildPythonPackage
, lib
, fetchPypi
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "amulet-nbt";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GoP4CrfsIig9+/viLRiU25MuUzSGtLVOAM43soff6pQ=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    numpy
  ];

  patches = [
    # ./fix-amulet-nbt-build.patch
  ];
}

