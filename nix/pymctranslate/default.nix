{ buildPythonPackage
, lib
, fetchPypi
  # dependencies
, setuptools
, amulet-nbt
, cython
, numpy
, versioneer
}:

buildPythonPackage rec {
  pname = "PyMCTranslate";
  version = "1.2.23";

  src = fetchPypi {
    inherit version;
    pname = "pymctranslate";
    sha256 = "sha256-fdDT2FwQluD4hTBPQrHUEG9CBDbyrviQS2i+6vJfDag=";
  };

  doCheck = false;

  build-system = [
    setuptools
    cython
    versioneer
  ];

  dependencies = [
    numpy
    amulet-nbt
  ];
}
