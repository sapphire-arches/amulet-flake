{ buildPythonPackage
, fetchPypi
, lib
  # dependencies
, cython
, numpy
, setuptools
, versioneer
, zlib
}:

buildPythonPackage rec {
  pname = "amulet-leveldb";
  version = "1.0.2";

  src = fetchPypi {
    inherit version;
    pname = "amulet_leveldb";
    sha256 = "sha256-s6pRHvcb9rxrIeljlb3tDzkrHcCT71jVU1Bn2Aq0FUE=";
  };

  pyproject = true;

  buildInputs = [
    zlib
  ];

  build-system = [
    cython
    setuptools
    versioneer
  ];

  dependencies = [
    numpy
  ];
}
