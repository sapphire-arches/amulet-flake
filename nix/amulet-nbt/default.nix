{ buildPythonPackage
, lib
, fetchPypi
  # dependencies
, cython
, mutf8
, numpy
, setuptools
, versioneer_518
}:

buildPythonPackage rec {
  pname = "amulet-nbt";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qd5P4GgynHqSHwndTOw3wlwBrCq+tOEAAOguUm420Pw=";
  };

  pyproject = true;

  nativeBuildInputs = [
    cython
  ];

  build-system = [
    setuptools
    versioneer_518
  ];

  dependencies = [
    numpy
    mutf8
  ];
}

